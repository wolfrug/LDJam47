using UnityEngine;
using System.Collections;

[CreateAssetMenu(fileName = "Data", menuName = "ScriptableObjectBase", order = 1)]
public class ScriptableObjectBase : ScriptableObject {
    public string name_;

    public virtual void Init(GameObject initializer = null){
        Debug.Log("Initializing dataobject " + name_);
    }
}
