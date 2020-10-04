using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TaskProgressor : MonoBehaviour {
    public TaskData targetData;
    public float currentTaskProgress = 0f;
    public float maxTaskProgress = 1f;
    // Start is called before the first frame update
    void Start () {
        currentTaskProgress = 0f;
        if (targetData.isPercentageTask) {
            maxTaskProgress = 1f;
        } else {
            maxTaskProgress = targetData.targetValue;
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