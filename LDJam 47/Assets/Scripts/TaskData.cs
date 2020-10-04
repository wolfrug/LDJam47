using System.Collections;
using UnityEngine;

[CreateAssetMenu (fileName = "Data", menuName = "TaskData", order = 1)]
public class TaskData : ScriptableObjectBase {

    public string description;
    public float targetValue;
    public bool isPercentageTask = true;
    public GameObject taskPrefab;
}