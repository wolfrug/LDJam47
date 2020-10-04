using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class GameManager : MonoBehaviour {

    public static GameManager instance;
    public static TaskProgressor currentProgressor;
    private bool failedTask = false;
    public MemoryPuzzle memoryPuzzle;
    public VacuumShaders.CurvedWorld.Example.Perspective2D_PlatformerUserControl playerController;

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