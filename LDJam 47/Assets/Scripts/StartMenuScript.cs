using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class StartMenuScript : MonoBehaviour {
    // Start is called before the first frame update[NaughtyAttributes.Button]

    public GameObject resetButton;
    public string sceneToLoadOnStart = "Main2DScene";

    void Start () {
        if (ES3.KeyExists ("LDJam47_HasSaved")) {
            resetButton.SetActive (true);
        } else {
            resetButton.SetActive (false);
        }
    }
    public void StartGame () {
        SceneManager.LoadScene (sceneToLoadOnStart);
    }
    public void ResetAll () {
        ES3.DeleteKey ("LDJam47_HasSaved");
        ES3.DeleteKey ("LDJam47_CurrentLevel");
        ES3.DeleteKey ("LDJam47_CurrentXP");
    }
    public void Quit () {
        Application.Quit ();
    }
}