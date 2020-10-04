using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

[System.Serializable]
public class TaskFinished : UnityEvent<TaskProgressor> { }

[System.Serializable]
public class TaskStarted : UnityEvent<TaskProgressor> { }

public class TaskProgressor : MonoBehaviour {
    public TaskData targetData;
    public float currentTaskProgress = 0f;
    public float progressGivenPerPuzzleSuccess = 1f;
    private float maxTaskProgress = 1f;
    public bool disablePlayerMovement = true;
    public TaskStarted evt_taskStarted;
    public TaskFinished evt_taskFinished;

    //public string TaskEventName = "MemoryPuzzle_Start";
    // Start is called before the first frame update
    void Start () {
        currentTaskProgress = 0f;
        if (targetData.isPercentageTask) {
            maxTaskProgress = 1f;
        } else {
            maxTaskProgress = targetData.targetValue;
        }
    }

    public void StartTask () {
        GameManager.currentProgressor = this;
        Doozy.Engine.GameEventMessage.SendEvent (targetData.puzzleEventName);
        evt_taskStarted.Invoke (this);
        if (disablePlayerMovement) {
            GameManager.instance.EnablePlayerControl (false);
        }
    }
    public void FinishTask () {
        evt_taskFinished.Invoke (this);
        if (disablePlayerMovement) {
            GameManager.instance.EnablePlayerControl (true);
        }
    }

    public void AddProgress (float amount) {
        currentTaskProgress = Mathf.Clamp (currentTaskProgress + amount, 0f, maxTaskProgress);
        if (targetData.isPercentageTask) {
            TaskMenuController.instance.SetProgressTask (targetData, currentTaskProgress);
        } else {
            TaskMenuController.instance.SetProgressTask (targetData, currentTaskProgress / maxTaskProgress);
        }
    }

    // Update is called once per frame
    void Update () {

    }
}