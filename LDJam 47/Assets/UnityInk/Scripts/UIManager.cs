using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.SceneManagement;
using UnityEngine.Tilemaps;
using UnityEngine.UI;

[System.Serializable]
public class GameSavedEvent : UnityEvent<string> { }

public class UIManager : MonoBehaviour {
    public static UIManager instance;
    public Canvas canvas;

    // How long is each day?
    public int dayLength = 100;
    public int daysSinceStart = 0;
    public InkCharacterObject[] characters;
    public Transform portraitParent;
    public GenericLoadingBar loadingBar;
    [SerializeField]
    private UIResourceObject[] allResourceObjects;
    public GameObject resourceAddedPrefab;
    public GameObject resourceRemovedPrefab;
    public Transform resourceAddedParent;
    public InkUIElementIconData iconData;
    public GameObject inGameMenuObject;
    public UIResourceObject mainObjectiveObject;
    private GenericTooltip mainObjectiveTooltip;
    private Dictionary<string, InkUIIcon> iconsDict = new Dictionary<string, InkUIIcon> { };
    private Dictionary<string, ProgressBar> progressBars = new Dictionary<string, ProgressBar> { };
    private Dictionary<string, InkCharacterObject> charactersDict = new Dictionary<string, InkCharacterObject> { };
    private Dictionary<InkCharacterObject, GameObject> spawnedPortraits = new Dictionary<InkCharacterObject, GameObject> { };
    public GameSavedEvent evt_gameSaved;
    void Awake () {
        if (instance == null) {
            instance = this;
        } else {
            Destroy (this);
        }
    }

    // Start is called before the first frame update
    void Start () {
        foreach (InkCharacterObject ico in characters) {
            charactersDict.Add (ico.characterName, ico);
        }
        foreach (InkUIIcon icon in iconData.icons) {
            iconsDict.Add (icon.InkVariable, icon);
        }
        allResourceObjects = FindObjectsOfType<UIResourceObject> ();
        
        //Get the tooltip for the main objective
        //mainObjectiveTooltip = mainObjectiveObject.GetComponentInChildren<GenericTooltip> ();
    }
    public void Init () {
        //bool savedGame = PlayerPrefs.GetInt("ClayDemo_hasSaved") > 0;
        bool savedGame = ES3.KeyExists ("ClayDemo_HasSaved");
        if (savedGame) {
            LoadGame ();
        } else {
            UIManager.instance.loadingBar.AddToState (1);
            InkWriter.main.StartStory ();
        }

    }
    void InitResourceObjs () {
        foreach (UIResourceObject obj in allResourceObjects) {
            obj.Init ();
        }
    }

    public void AddProgressBar (ProgressBar bar) {
        if (!progressBars.ContainsValue (bar)) {
            progressBars.Add (bar.barName, bar);
            bar.SetValueToInkValue ();
        }
    }

    public void UpdateProgressBar (string tag, int value) {
        ProgressBar outBar;
        progressBars.TryGetValue (tag, out outBar);
        if (outBar != null) {
            outBar.SetValue (value);
        }
    }

    public void ChangePortrait (object[] inputVariables) {
        // assume there is only one object in the list
        Debug.Log (inputVariables[0]);
        string character = inputVariables[0].ToString ();
        InkCharacterObject outVar;
        charactersDict.TryGetValue (character, out outVar);
        Debug.Log (outVar?.characterName);
        // Is the portrait already spawned?
        GameObject tryGetObject = null;
        spawnedPortraits.TryGetValue (outVar, out tryGetObject);
        // If spawned, make it visible and make all others invisible
        if (tryGetObject != null) {
            DeactivatePortraits ();
            tryGetObject.SetActive (true);

        } else { // otherwise, spawn it - and make everything else invisible.
            DeactivatePortraits ();
            GameObject newPortrait = Instantiate (outVar.portraitPrefab, portraitParent);
            spawnedPortraits.Add (outVar, newPortrait);
        }

    }

    void DeactivatePortraits () {
        foreach (KeyValuePair<InkCharacterObject, GameObject> entry in spawnedPortraits) {
            entry.Value.SetActive (false);
        }
    }
    public void PauseGame (bool pause) {
        //        GameManager.instance.PauseGame (pause);
    }

    public void SaveGame () {
        /*Vector3 playerPos = player.transform.position;
        //PlayerPrefs.SetInt("ClayDemo_hasSaved", 1);
        ES3.Save<bool>("ClayDemo_HasSaved", true);
        InkWriter.main.story.variablesState["playerX"] = playerPos.x;
        InkWriter.main.story.variablesState["playerY"] = playerPos.y;
        InkWriter.main.story.variablesState["playerZ"] = playerPos.z;
        InkWriter.main.SaveStory();
        evt_gameSaved.Invoke("SlotDefault");
        //        Debug.Log ("Saved Player Pos X: " + (float) InkWriter.main.story.variablesState["playerX"]);
        */
    }
    public void LoadGame () {
        /*Debug.Log("Loading game!");
        InkWriter.main.LoadStory();
        Transform playerTr = GameObject.FindGameObjectWithTag("Player").transform;
        Vector3 playerNewPos = new Vector3 { };
        playerNewPos.x = (float)InkWriter.main.story.variablesState["playerX"];
        playerNewPos.y = (float)InkWriter.main.story.variablesState["playerY"];
        playerNewPos.z = (float)InkWriter.main.story.variablesState["playerZ"];
        playerTr.position = playerNewPos;
        player.pathfinder.SnapToSpotDebug();
        // Make sure location visibility is properly updated
        GridObjectManager.instance.UpdateLocationVisibility();
        Invoke("LateLoad", 0.1f);
        UIManager.instance.loadingBar.AddToState(1);
        // Load the latest objective
        LoadMainObjective();
        //Invoke ("SetUpPlayerCamp", 0.1f);
        */
    }
    public void OpenJournal () {
        if (!InkWriter.main.writerVisible) {
            InkWriter.main.GoToKnot ("OpenJournalExt");
        }
    }
    public void CloseJournal () {
        // We don't really need to do anything, it should just close itself
    }

    public void Restart () {
        //GameManager.instance.Restart();
        SceneManager.LoadScene (SceneManager.GetActiveScene ().name);
    }

    [NaughtyAttributes.Button]
    public void ResetGame () {
        //PlayerPrefs.SetInt("ClayDemo_hasSaved", 0);
        ES3.DeleteKey ("ClayDemo_HasSaved");
        FindObjectOfType<InkWriter> ().ResetStory ();
        InkWriter.main.ResetStory ();
        SceneManager.LoadScene (SceneManager.GetActiveScene ().name);
    }

    public void QuitGame () {
        //GameManager.instance.QuitGame();
        Application.Quit ();
    }

    public void WinGame () {
        //GameManager.instance.WinGame();
    }

    public void SpawnResourceEffect (string name, int value) {
        if (value != 0) {
            GameObject effGO = null;
            InkUIIcon data;
            Sprite icon = null;
            iconsDict.TryGetValue (name, out data);
            if (data != null) {
                icon = data.icon;
                string numberText = value.ToString ();
                if (value < 0) {
                    effGO = Instantiate (resourceRemovedPrefab, resourceAddedParent);
                } else {
                    effGO = Instantiate (resourceAddedPrefab, resourceAddedParent);
                    numberText = "+" + value.ToString ();
                }
                GenericWorldTextEffect effs = effGO.GetComponent<GenericWorldTextEffect> ();
                string finalText = string.Format (data.textFormat, numberText);
                effs.SetUp (finalText, icon, true);
            };
        };
    }
    public void SpawnResourceEffectBool (string name, bool value) {
        GameObject effGO = null;
        InkUIIcon data;
        Sprite icon = null;
        iconsDict.TryGetValue (name, out data);
        if (data != null) {
            icon = data.icon;
            string numberText = value.ToString ();
            if (!value) {
                effGO = Instantiate (resourceRemovedPrefab, resourceAddedParent);
            } else {
                effGO = Instantiate (resourceAddedPrefab, resourceAddedParent);
                numberText = "+" + value.ToString ();
            }
            GenericWorldTextEffect effs = effGO.GetComponent<GenericWorldTextEffect> ();
            string finalText = string.Format (data.textFormat, numberText);
            effs.SetUp (finalText, icon, true);
        };
    }

}