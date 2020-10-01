using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class LoadFMOD : MonoBehaviour {

    public string sceneName = "SampleScene";
    public string lastBank = "Master";
    // Start is called before the first frame update
    

    // Update is called once per frame
    void Update () {
        if (FMODUnity.RuntimeManager.HasBankLoaded (lastBank)) {
            Debug.Log ("Master Bank Loaded");
            SceneManager.LoadScene (sceneName, LoadSceneMode.Single);
        }
    }
}