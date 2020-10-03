using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LoopTeleporter : MonoBehaviour {
    public bool active;
    public Transform leftRoom;
    public Transform rightRoom;

    public void EnableTeleporter (bool enable) {
        active = enable;
    }
    public void LoopLeftRight (GameObject obj) {
        LoopObject (obj, leftRoom, rightRoom);
    }
    public void LoopRightLeft (GameObject obj) {
        LoopObject (obj, rightRoom, leftRoom);
    }
    public void LoopObject (GameObject obj, Transform fromRoom, Transform toRoom) {
        if (active) {
            Debug.Log ("Looping " + obj + " from " + fromRoom + " to " + toRoom);
            //Add object as child to fromRoom
            obj.transform.parent = fromRoom;
            // Get its local pos
            Vector3 localPos = obj.transform.localPosition;
            // Set it as child of toRoom
            obj.transform.parent = toRoom;
            // Set its localPos to be the same as it was in the original room
            obj.transform.localPosition = localPos;
            // unparent the obj
            obj.transform.parent = null;
        } else {
            Debug.Log ("Teleport disabled!", gameObject);
        }
    }
}