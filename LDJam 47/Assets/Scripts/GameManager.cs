using System.Collections;
using System.Collections.Generic;
using Doozy.Engine.Progress;
using TMPro;
using UnityEngine;
using UnityEngine.SceneManagement;

public class GameManager : MonoBehaviour {

    public static GameManager instance;
    public static TaskProgressor currentProgressor;
    private bool failedTask = false;
    public MemoryPuzzle memoryPuzzle;
    public VacuumShaders.CurvedWorld.Example.Perspective2D_PlatformerUserControl playerController;
    public BasicAgent playerAgent;
    public TextMeshProUGUI levelText;
    public Animator levelUpAnimator;
    private int currentLevel = 1;
    private float currentXP = 0f;
    public Progressor mainXPProgressor;

    void Awake () {
        if (instance == null) {
            instance = this;
        } else {
            Destroy (gameObject);
        }
    }
    // Start is called before the first frame update
    void Start () {
        TaskMenuController.instance.evt_taskprogressed.AddListener (FinalLoopTaskComplete);
        //memoryPuzzle.evt_puzzleSuccess.AddListener (ProgressTask);
        //memoryPuzzle.evt_puzzleFailed.AddListener (FailTask);
        //yield return new WaitForSeconds (0.1f);
        if (ES3.KeyExists ("LDJam47_HasSaved")) {
            //ActionWaiter (1f, new System.Action (() => InkWriter.main.GoToKnot ("daily_cycle")));
            currentLevel = ES3.Load<int> ("LDJam47_CurrentLevel");
            currentXP = ES3.Load<float> ("LDJam47_CurrentXP");
            levelText.text = "Level " + currentLevel;
            mainXPProgressor.SetProgress (currentXP);
        }
    }

    [NaughtyAttributes.Button]
    void ResetAll () {
        ES3.DeleteKey ("LDJam47_HasSaved");
        ES3.DeleteKey ("LDJam47_CurrentLevel");
        ES3.DeleteKey ("LDJam47_CurrentXP");
        InkWriter.main.ResetStory ();
        SceneManager.LoadScene (SceneManager.GetActiveScene ().name);
    }

    public void SaveAndQuit () {
        ES3.Save<bool> ("LDJam47_HasSaved", true);
        ES3.Save<int> ("LDJam47_CurrentLevel", currentLevel);
        ES3.Save<float> ("LDJam47_CurrentXP", currentXP);
        InkWriter.main.story.variablesState["loopNumber"] = (int) InkWriter.main.story.variablesState["loopNumber"] + 1;
        InkWriter.main.story.variablesState["level"] = currentLevel;
        InkWriter.main.SaveStory ();
        SceneManager.LoadScene (SceneManager.GetActiveScene ().name);
    }

    public void DoNotSaveAndQuit () {
        SceneManager.LoadScene ("MainMenu");
    }

    public void WinGame () {
        SceneManager.LoadScene ("EndScene");
    }

    public void AddTaskXPRandom () {
        // Adds some random XP for a task
        currentXP += Random.Range (0.2f, 0.6f);
        Debug.Log ("Setting XP progress to " + currentXP);
        mainXPProgressor.SetProgress (currentXP);
        if (currentXP >= 1f) {
            DelayActionUntil (new System.Func<bool> (() => mainXPProgressor.Progress >= 1f), new System.Action (() => LevelUp ()));
        }
    }

    public void LevelUp () { // When it reaches 1, level up and reset
        Debug.Log ("Leveling up! From " + currentLevel + " to " + currentLevel + 1);
        mainXPProgressor.SetProgress (0f);
        currentLevel++;
        currentXP = 0f;
        levelUpAnimator.SetTrigger ("LevelUp");
        ActionWaiter (0.5f, new System.Action (() => levelText.text = "Level " + currentLevel));
    }

    public void PlayerOutOfEnergy () {
        playerAgent.Kill ();
        Doozy.Engine.GameEventMessage.SendEvent ("PlayerDead");
    }

    public void EnablePlayerControl (bool enable) {
        playerController.enabled = enable;
    }

    void FinalLoopTaskComplete (TaskData data, float completion) {
        if (data == TaskMenuController.instance.finalTask && completion == 1f) {
            Debug.Log ("We win!");
            Doozy.Engine.GameEventMessage.SendEvent ("GameLoopFinished");
        }
    }

    public void FailTask () {
        failedTask = true;
    }
    public void ProgressTask () {
        failedTask = false;
    }

    public void UpdateTasks () {
        if (currentProgressor != null && failedTask) {
            TaskMenuController.instance.FailTask (currentProgressor.targetData);
            currentProgressor.FinishTask ();
            currentProgressor = null;
        } else if (currentProgressor != null && !failedTask) {
            currentProgressor.AddProgress (currentProgressor.progressGivenPerPuzzleSuccess);
            currentProgressor.FinishTask ();
            currentProgressor = null;
            AddTaskXPRandom ();
        };
    }

    public void ActionWaiter (float timeToWait, System.Action callBack) {
        StartCoroutine (ActionWaiterCoroutine (timeToWait, callBack));
    }
    IEnumerator ActionWaiterCoroutine (float timeToWait, System.Action callBack) {
        yield return new WaitForSeconds (timeToWait);
        callBack.Invoke ();
    }

    public void DelayActionUntil (System.Func<bool> condition, System.Action callBack) {
        StartCoroutine (DelayActionCoroutine (condition, callBack));
    }
    IEnumerator DelayActionCoroutine (System.Func<bool> condition, System.Action callBack) {

        bool outvar = false;
        while (!outvar) {
            outvar = condition ();
            yield return new WaitForSeconds (0.1f);
        };
        Debug.Log ("Delayed action finished?!");
        callBack.Invoke ();
    }

    // Update is called once per frame
    void Update () {

    }
}