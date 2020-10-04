using System.Collections;
using System.Collections.Generic;
using Doozy.Engine.Progress;
using TMPro;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.UI;

[System.Serializable]
public class TaskProgressed : UnityEvent<TaskData, float> { }

public class TaskMenuController : MonoBehaviour {
    public static TaskMenuController instance;
    public TaskData[] loopingTasks;
    public List<TaskProgressor> allTaskProgressors;
    public Transform taskParent;
    public Animator allTasksCompleteAnimator;
    public TaskData finalTask;
    bool isOnFinalTask;
    public GameObject offScreenArrowPrefab;
    public Transform playerTransform;
    public GameObject finalTaskInteractorObject;
    public TextMeshProUGUI tasksLeftText;
    private List<GameObject> spawnedTasks = new List<GameObject> { };
    private Dictionary<TaskData, Progressor> taskListDict = new Dictionary<TaskData, Progressor> { };
    private Dictionary<TaskData, Animator> taskListAnimatorDict = new Dictionary<TaskData, Animator> { };
    private Dictionary<TaskData, TaskProgressor> taskProgressorDict = new Dictionary<TaskData, TaskProgressor> { };
    private Dictionary<TaskData, OffScreenArrow> arrowsDict = new Dictionary<TaskData, OffScreenArrow> { };
    public List<TaskData> finishedTasks;
    public List<TaskData> unfinishedTasks;
    public List<TaskData> failedTasks;

    public TaskProgressed evt_taskprogressed;

    void Awake () {
        if (instance == null) {
            instance = this;
        } else {
            Destroy (gameObject);
        }
    }
    // Start is called before the first frame update
    void Start () {
        foreach (TaskProgressor tp in allTaskProgressors) {
            taskProgressorDict.Add (tp.targetData, tp);
        }
        PopulateList ();
        finalTaskInteractorObject.SetActive (false);
    }

    [NaughtyAttributes.Button]
    void AutoAddTaskProgressors () {
        allTaskProgressors.Clear ();
        foreach (TaskProgressor tp in FindObjectsOfType<TaskProgressor> ()) {
            allTaskProgressors.Add (tp);
        }
    }

    public void PopulateList () {
        finishedTasks.Clear ();
        unfinishedTasks.Clear ();
        failedTasks.Clear ();
        foreach (GameObject obj in spawnedTasks) {
            Destroy (obj);
        }
        foreach (TaskData data in loopingTasks) {
            SpawnTask (data);
            unfinishedTasks.Add (data);
        }
        UpdateText ();
    }

    void UpdateText () {
        tasksLeftText.text = string.Format ("Assigned Tasks: ({0}/{1})", finishedTasks.Count + failedTasks.Count, unfinishedTasks.Count + finishedTasks.Count + failedTasks.Count);
    }
    void CheckTaskCompletion () {
        if (!isOnFinalTask) {
            if (unfinishedTasks.Count == 0) {
                allTasksCompleteAnimator.SetBool ("AllComplete", true);
                GameManager.instance.ActionWaiter (2f, new System.Action (() => SpawnTask (finalTask)));
                finalTaskInteractorObject.SetActive (true);
                isOnFinalTask = true;
            } else {
                allTasksCompleteAnimator.SetBool ("AllComplete", false);
            }
        };
    }

    void SpawnTask (TaskData data) {
        GameObject spawnedObject = Instantiate (data.taskPrefab, taskParent);
        Progressor progComponent = spawnedObject.GetComponent<Progressor> ();
        Debug.Log (progComponent.ProgressTargets[1]);
        TextMeshProUGUI textTarget = spawnedObject.transform.Find ("AnimatorParent/DescriptionText").GetComponent<TextMeshProUGUI> ();
        textTarget.text = data.description;
        if (!data.isPercentageTask) {
            (progComponent.ProgressTargets[1] as ProgressTargetTextMeshPro).Suffix = " / " + data.targetValue.ToString ();
            (progComponent.ProgressTargets[1] as ProgressTargetTextMeshPro).Multiplier = data.targetValue;
        }
        // We'd do this dynamically but without intellisense it takes too long
        //progComponent.SetMax(data.targetValue);
        //progComponent.SetMin(0f);
        taskListDict.Add (data, progComponent);
        taskListAnimatorDict.Add (data, spawnedObject.GetComponent<Animator> ());
        spawnedTasks.Add (spawnedObject);
        ShowTask (data);
    }

    public void AddTaskArrow (TaskData data) { // adds an arrow that points towards the task!
        if (!arrowsDict.ContainsKey (data)) {
            TaskProgressor target;
            taskProgressorDict.TryGetValue (data, out target);
            if (target != null) {
                OffScreenArrow arrow = Instantiate (offScreenArrowPrefab).GetComponent<OffScreenArrow> ();
                arrow.lineRenderertarget = playerTransform;
                arrow.widgetTarget = playerTransform;
                arrow.origin = target.transform;
                arrowsDict.Add (data, arrow);
            }
        } else {
            OffScreenArrow arrow;
            arrowsDict.TryGetValue (data, out arrow);
            if (arrow != null) {
                arrow.gameObject.SetActive (true);
            } else {
                arrowsDict.Remove (data);
            }
        }
    }
    public void RemoveTaskArrow (TaskData data) { // removes the arrow (if it exists) that points towards the task!
        Debug.Log ("Attempting to remove arrow for data " + data.name_);
        if (arrowsDict.ContainsKey (data)) {
            Debug.Log ("Found the key!");
            OffScreenArrow arrow;
            arrowsDict.TryGetValue (data, out arrow);
            if (arrow != null) {
                Debug.Log ("Setting to inactive, yes!");
                arrow.gameObject.SetActive (false);
            } else {
                Debug.Log ("Somehow did not find it??");
                arrowsDict.Remove (data);
            }
        }
    }

    public void SetProgressTask (TaskData data, float toAmount) {
        Progressor outProgressor;
        taskListDict.TryGetValue (data, out outProgressor);
        if (outProgressor != null) {
            outProgressor.SetProgress (toAmount);
            evt_taskprogressed.Invoke (data, toAmount);
            AnimateTask (data);
            if (toAmount >= 1f) {
                GameManager.instance.DelayActionUntil (new System.Func<bool> (() => outProgressor.Progress >= 1f), new System.Action (() => FinishTask (data)));
            }
        } else {
            Debug.LogWarning ("No such progressor found!");
        }
    }

    void ShowTask (TaskData data) {
        Animator targetAnimator;
        taskListAnimatorDict.TryGetValue (data, out targetAnimator);
        if (targetAnimator != null) {
            targetAnimator.SetBool ("Active", true);
        }
        AddTaskArrow (data);
    }
    void HideTask (TaskData data) {
        Animator targetAnimator;
        taskListAnimatorDict.TryGetValue (data, out targetAnimator);
        if (targetAnimator != null) {
            targetAnimator.SetBool ("Active", false);
        }
        RemoveTaskArrow (data);
    }
    void AnimateTask (TaskData data) {
        Animator targetAnimator;
        taskListAnimatorDict.TryGetValue (data, out targetAnimator);
        if (targetAnimator != null) {
            targetAnimator.SetTrigger ("Progress");
        }
    }
    public void FinishTask (TaskData data) {
        Animator targetAnimator;
        taskListAnimatorDict.TryGetValue (data, out targetAnimator);
        if (targetAnimator != null) {
            targetAnimator.SetBool ("Failed", false);
            targetAnimator.SetBool ("Completed", true);
        }
        if (!finishedTasks.Contains (data)) {
            finishedTasks.Add (data);
        }
        if (unfinishedTasks.Contains (data)) {
            unfinishedTasks.Remove (data);
        }
        UpdateText ();
        RemoveTaskArrow (data);
        CheckTaskCompletion ();
    }
    public void FailTask (TaskData data) {
        Animator targetAnimator;
        taskListAnimatorDict.TryGetValue (data, out targetAnimator);
        if (targetAnimator != null) {
            targetAnimator.SetBool ("Failed", true);
            targetAnimator.SetBool ("Completed", false);
        }
        if (!failedTasks.Contains (data)) {
            failedTasks.Add (data);
        }
        if (unfinishedTasks.Contains (data)) {
            unfinishedTasks.Remove (data);
        }
        UpdateText ();
        RemoveTaskArrow (data);
        CheckTaskCompletion ();
    }

    [NaughtyAttributes.Button]
    void DebugProgress () {
        SetProgressTask (loopingTasks[0], 1f);
        SetProgressTask (loopingTasks[1], 1f);
    }

    // Update is called once per frame
    void Update () {

    }
}