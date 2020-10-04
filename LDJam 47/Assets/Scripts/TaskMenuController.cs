using System.Collections;
using System.Collections.Generic;
using Doozy.Engine.Progress;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class TaskMenuController : MonoBehaviour {
    public TaskData[] loopingTasks;
    public GameObject percentageTaskPrefab;
    public GameObject nrTaskPrefab;
    public Transform taskParent;
    public TextMeshProUGUI tasksLeftText;
    private List<GameObject> spawnedTasks = new List<GameObject> { };
    private Dictionary<TaskData, Progressor> taskListDict = new Dictionary<TaskData, Progressor> { };
    private Dictionary<TaskData, Animator> taskListAnimatorDict = new Dictionary<TaskData, Animator> { };
    public List<TaskData> finishedTasks;
    public List<TaskData> unfinishedTasks;
    public List<TaskData> failedTasks;
    // Start is called before the first frame update
    void Start () {
        PopulateList ();
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

    void SpawnTask (TaskData data) {
        GameObject spawnedObject = Instantiate (data.taskPrefab, taskParent);
        Progressor progComponent = spawnedObject.GetComponent<Progressor> ();
        Debug.Log (progComponent.ProgressTargets[1]);
        TextMeshProUGUI textTarget = spawnedObject.transform.Find ("AnimatorParent/DescriptionText").GetComponent<TextMeshProUGUI> ();
        textTarget.text = data.description;
        // We'd do this dynamically but without intellisense it takes too long
        //progComponent.SetMax(data.targetValue);
        //progComponent.SetMin(0f);
        taskListDict.Add (data, progComponent);
        taskListAnimatorDict.Add (data, spawnedObject.GetComponent<Animator> ());
        ShowTask (data);
    }

    public void SetProgressTask (TaskData data, float toAmount) {
        Progressor outProgressor;
        taskListDict.TryGetValue (data, out outProgressor);
        if (outProgressor != null) {
            outProgressor.SetProgress (toAmount);
            AnimateTask (data);
            if (toAmount >= 1f) {
                DelayActionUntil (new System.Func<bool> (() => outProgressor.Progress >= 1f), new System.Action (() => FinishTask (data)));
            }
        } else {
            Debug.LogWarning ("No such progressor found!");
        }
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

    void ShowTask (TaskData data) {
        Animator targetAnimator;
        taskListAnimatorDict.TryGetValue (data, out targetAnimator);
        if (targetAnimator != null) {
            targetAnimator.SetBool ("Active", true);
        }
    }
    void HideTask (TaskData data) {
        Animator targetAnimator;
        taskListAnimatorDict.TryGetValue (data, out targetAnimator);
        if (targetAnimator != null) {
            targetAnimator.SetBool ("Active", false);
        }
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