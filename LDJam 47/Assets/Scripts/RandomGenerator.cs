using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[System.Serializable]
public class RandomObject {
    public GameObject prefab;
    public float weight;
    [Tooltip ("Rotate randomly (- to +) on spawn.")]
    public Vector3 rotateRandomly = Vector3.zero;
    [Tooltip ("Random rotation is either + or - or 0 of each vector3, not a random range.")]
    public bool straightAnglesOnly = true;
    [Tooltip ("-1 -> infinite. If it's any other nr than infinite, it will be force-spawned too")]
    public int spawnAmount = -1;
}
public class RandomGenerator : MonoBehaviour { // simple random generator script

    [Tooltip ("Set to larger than 0 to use a set seed!")]
    public int randomSeed = 0;
    public RandomObject[] randomObjects;
    [Tooltip ("Leave empty if you do not wish to use this function (finding a transform named whatever and using its localScale to determine the size of the object")]
    public string groundTransformName = "Ground";
    public Vector3 defaultGroundSize = new Vector3 (10f, 0f, 10f);
    public int spawnObjectsMin = 25;
    public int spawnObjectsMax = 50;
    // how many times it tries to place an object before giving up
    public int spawnIterations = 20;

    [HideInInspector]
    public int spawnCounter = 0;
    public Vector3 maxExtents = new Vector3 (100f, 0f, 100f);
    public bool finished = false;
    public LayerMask overlapCheckMask;
    private Vector3 lastPosition = Vector3.zero;
    private Dictionary<RandomObject, float> spawnables = new Dictionary<RandomObject, float> { };
    private Dictionary<GameObject, float> spawnedObjects = new Dictionary<GameObject, float> { };

    private List<GameObject> queuedForceSpawnedObjects = new List<GameObject> ();

    // Start is called before the first frame update
    public IEnumerator Init () {
        finished = false;
        if (randomSeed != 0) {
            Random.InitState (randomSeed);
        }
        // start position is location of the spawner obejct
        lastPosition = transform.position;
        // and max extents are counted from the spawner object
        maxExtents = new Vector3 (lastPosition.x + maxExtents.x, lastPosition.y + maxExtents.y, lastPosition.z + maxExtents.z);

        foreach (RandomObject obj in randomObjects) {
            spawnables.Add (obj, obj.weight);
        }
        // regular spawn
        spawnCounter = spawnObjectsMax;
        while (spawnCounter > 0) {
            yield return null;
            //Debug.Log (spawnables.RandomElementByWeight (e => e.Value));
            spawnCounter--;
            SpawnObject (spawnables.RandomElementByWeight (e => e.Value, randomSeed).Key);
        };
        // check to make sure all force-spawned objects were spawned during the regular spawn. and if not, spawn them
        foreach (RandomObject obj in randomObjects) {
            if (obj.spawnAmount > 0) {
                while (obj.spawnAmount > 0) {
                    yield return new WaitForEndOfFrame ();
                    SpawnObjectRandom (obj);
                };
            }
        }
        if (queuedForceSpawnedObjects.Count > 0) {
            // if there are any queued force spawn objects, we try to place them now
            for (int i = 0; i < queuedForceSpawnedObjects.Count; i++) {
                yield return new WaitForEndOfFrame ();
                if (PlaceObject (queuedForceSpawnedObjects[i], true, true)); {
                    queuedForceSpawnedObjects.RemoveAt (i);
                }
            }
        };
        // If there are somehow still force spawn objects left, throw error
        if (queuedForceSpawnedObjects.Count > 0) {
            Debug.LogWarning ("Could not place the following force-spawn objects for some reason!");
            foreach (GameObject obj in queuedForceSpawnedObjects) {
                Debug.Log (obj.name, obj);
            }
        }
        Random.InitState ((int) System.DateTime.Now.Second);
        // And we're done
        finished = true;
    }

    void SpawnObject (RandomObject obj) {
        if (obj.spawnAmount < 0) {
            GameObject newObj = Instantiate (obj.prefab, transform);
            RotateObject (newObj, obj.rotateRandomly, obj.straightAnglesOnly);
            PlaceObject (newObj);
        } else if (obj.spawnAmount > 0) {
            obj.spawnAmount--;
            GameObject newObj = Instantiate (obj.prefab, transform);
            RotateObject (newObj, obj.rotateRandomly, obj.straightAnglesOnly);
            PlaceObject (newObj, true, true);
        } else {
            if (SpawnedObjectCount () < spawnObjectsMin) {
                spawnCounter++;
            };
            // Debug.Log ("Did not spawn, already reached max spawnAmount: " + obj);
        }
    }
    public int SpawnedObjectCount () {
        return spawnedObjects.Count;
    }

    void RotateObject (GameObject obj, Vector3 angles, bool straightAnglesOnly) {
        float x = obj.transform.rotation.eulerAngles.x;
        float y = obj.transform.rotation.eulerAngles.y;
        float z = obj.transform.rotation.eulerAngles.z;
        if (straightAnglesOnly) {
            List<float> randomPositionsX = new List<float> { angles.x, -angles.x, 0f };
            List<float> randomPositionsY = new List<float> { angles.y, -angles.y, 0f };
            List<float> randomPositionsZ = new List<float> { angles.z, -angles.z, 0f };
            x = randomPositionsX[Random.Range (0, randomPositionsX.Count)];
            y = randomPositionsY[Random.Range (0, randomPositionsY.Count)];
            z = randomPositionsZ[Random.Range (0, randomPositionsZ.Count)];
        } else {
            x = Random.Range (-angles.x, angles.x);
            y = Random.Range (-angles.y, angles.y);
            z = Random.Range (-angles.z, angles.z);
        }
        obj.transform.localRotation = Quaternion.Euler (x, y, z);
    }

    void SpawnObjectRandom (RandomObject obj) { // Used for after-the-fact spawning, to add more randomness to their placement
        if (obj.spawnAmount < 0) {
            GameObject newObj = Instantiate (obj.prefab, transform);
            RotateObject (newObj, obj.rotateRandomly, obj.straightAnglesOnly);
            ReplaceRandomInfiniteObjectWithForceSpawnedObject (newObj);
        } else if (obj.spawnAmount > 0) {
            obj.spawnAmount--;
            GameObject newObj = Instantiate (obj.prefab, transform);
            RotateObject (newObj, obj.rotateRandomly, obj.straightAnglesOnly);
            ReplaceRandomInfiniteObjectWithForceSpawnedObject (newObj);
        } else {
            if (SpawnedObjectCount () < spawnObjectsMin) {
                spawnCounter++;
            };

        };
        Debug.Log ("Did not spawn, already reached max spawnAmount: " + obj);
    }

    bool PlaceObject (GameObject obj, bool repeat = true, bool force = false) {
        // First try to place it randomly next to lastPosition 20 times...
        int iterations = spawnIterations;
        Transform ground = null;
        if (groundTransformName != "") {
            ground = obj.transform.Find (groundTransformName);
        };
        Vector3 comparePosition = defaultGroundSize;
        if (ground != null) {
            comparePosition = ground.localScale;
        }
        // so it doesn't hit itself!
        obj.SetActive (false);
        Loop:
            while (iterations > 0) {
                // testing: use default ground size for this instead
                Vector3 nextPosition = GetNextPosition (comparePosition);
                if (!Overlaps (nextPosition, obj, comparePosition)) {
                    obj.transform.position = nextPosition;
                    lastPosition = transform.position;
                    // add to dictionary
                    if (!force) {
                        spawnedObjects.Add (obj, 1f);
                    } else {
                        spawnedObjects.Add (obj, 0f);
                    }
                    obj.name = obj.name + spawnCounter.ToString ();
                    obj.SetActive (true);
                    return true;
                }
                iterations--;
            }
        // Then zero lastPosition and try again
        lastPosition = transform.position;
        if (repeat) {
            repeat = false;
            iterations = spawnIterations;
            goto Loop;
        } else { // we give up, delete object, unless set to force spawn!
            if (!force) {
                Destroy (obj);
                if (SpawnedObjectCount () < spawnObjectsMin) {
                    spawnCounter++;
                };
                return false;
            } else { // else we find another spawned object with infinite spawns, and replace it with this, or if we can't, we go back to trying to loop it...
                return ReplaceRandomInfiniteObjectWithForceSpawnedObject (obj);
            }
        }
    }

    bool ReplaceRandomInfiniteObjectWithForceSpawnedObject (GameObject obj) {
        if (spawnedObjects.Count > 0) {
            int iterations = 20;
            Transform ground = null;
            if (groundTransformName != "") {
                ground = obj.transform.Find (groundTransformName);
            };
            Vector3 comparePosition = defaultGroundSize;
            if (ground != null) {
                comparePosition = ground.localScale;
            }
            while (iterations > 0) {
                GameObject replaceableObject = spawnedObjects.RandomElementByWeight (e => e.Value, randomSeed).Key;
                if (spawnedObjects[replaceableObject] > 0f) { // check to see it's not accidentally a force-spawn object
                    replaceableObject.SetActive (false);
                    obj.SetActive (false);
                    Vector3 nextPosition = replaceableObject.transform.position;
                    if (!Overlaps (nextPosition, replaceableObject, comparePosition)) {
                        obj.transform.position = replaceableObject.transform.position;
                        spawnedObjects.Remove (replaceableObject);
                        spawnedObjects.Add (obj, 0f);
                        obj.SetActive (true);
                        Destroy (replaceableObject);
                        return true;
                    } else {
                        replaceableObject.SetActive (true);
                    }
                }
                iterations--;
            }
            // failed to find an appropriately (sized) object, hide, put into queue
            queuedForceSpawnedObjects.Add (obj);
            obj.transform.position = new Vector3 (9000f, 9000f, 9000f);
            return false;

        } else { // we couldn't find a spot for it, so we put into the queued list (and hide it)
            queuedForceSpawnedObjects.Add (obj);
            obj.transform.position = new Vector3 (9000f, 9000f, 9000f);
            return false;
        }
    }

    Vector3 GetNextPosition (Vector3 size) {
        List<float> randomPositionsX = new List<float> { size.x, -size.x, 0f };
        List<float> randomPositionsY = new List<float> { size.y, -size.y, 0f };
        List<float> randomPositionsZ = new List<float> { size.z, -size.z, 0f };
        float x = randomPositionsX[Random.Range (0, randomPositionsX.Count)];
        x = Mathf.Clamp (x + lastPosition.x, -maxExtents.x, maxExtents.x);
        float y = randomPositionsY[Random.Range (0, randomPositionsY.Count)];
        y = Mathf.Clamp (y + lastPosition.y, -maxExtents.y, maxExtents.y);
        float z = randomPositionsZ[Random.Range (0, randomPositionsZ.Count)];
        z = Mathf.Clamp (z + lastPosition.z, -maxExtents.z, maxExtents.z);
        lastPosition = new Vector3 (x, y, z);
        return lastPosition;
    }

    bool Overlaps (Vector3 targetPos, GameObject self, Vector3 comparePosition) {
        Vector3 testSize = new Vector3 (comparePosition.x * 0.9f, comparePosition.y * 0.9f, comparePosition.z * 0.9f);
        Collider[] hitColliders = Physics.OverlapBox (targetPos, testSize / 2f, self.transform.localRotation, overlapCheckMask);
        int i = 0;
        while (i < hitColliders.Length) {
            //Debug.Log ("Hit : " + hitColliders[i].name + i);
            if (hitColliders[i].gameObject != self) {
                return true;
            }
            i++;
        }
        return false;
    }

    // Update is called once per frame
    void Update () {

    }

}