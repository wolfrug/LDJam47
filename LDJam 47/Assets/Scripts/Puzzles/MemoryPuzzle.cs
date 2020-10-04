using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.UI;

[System.Serializable]
public class PuzzleSucceeded : UnityEvent<TaskData> { }

[System.Serializable]
public class PuzzleFailed : UnityEvent<TaskData> { }

public class MemoryPuzzle : MonoBehaviour {

    public Button[] puzzleButtons;
    public Sprite redButton;
    public Sprite whiteButton;
    public GameObject redLed;
    public GameObject greenLed;
    public List<int> randomSequence = new List<int> { };
    public int randomButtonNumber = 4;
    public int lastButtonPressed = -1;
    public float waitTime = 0.5f;
    public TaskData attachedData = null;
    public PuzzleSucceeded evt_puzzleSuccess;
    public PuzzleFailed evt_puzzleFailed;

    // Start is called before the first frame update
    void Start () {
        for (int i = 0; i < puzzleButtons.Length; i++) {
            Button puzzleButton = puzzleButtons[i];
            puzzleButton.onClick.AddListener (() => ButtonPressed (puzzleButton));
        }
    }

    void ButtonPressed (Button button) {
        Debug.Log ("Button pressed: " + button);
        lastButtonPressed = System.Array.IndexOf<Button> (puzzleButtons, button);
        GameManager.instance.ActionWaiter (waitTime, () => (button.targetGraphic as Image).sprite = whiteButton);
    }

    public void AssignData (TaskData data) {
        attachedData = data;
    }

    [NaughtyAttributes.Button]
    public void StartMemoryPuzzle () {
        //Doozy.Engine.GameEventMessage.SendEvent ("MemoryPuzzle_Start");
        GameManager.instance.ActionWaiter (1f, () => CreateRandomSequence ());
    }

    void CreateRandomSequence () { // creates the sequence, then plays it
        redLed.SetActive (false);
        greenLed.SetActive (false);
        randomSequence.Clear ();
        for (int i = 0; i < randomButtonNumber; i++) {
            int index = Random.Range (0, puzzleButtons.Length);
            randomSequence.Add (index);
        }
        StartCoroutine (PlayRandomSequence ());
    }
    IEnumerator PlayRandomSequence () {
        DisableAll ();
        foreach (int i in randomSequence) {
            yield return new WaitForSeconds (waitTime);
            (puzzleButtons[i].targetGraphic as Image).sprite = redButton;
            yield return new WaitForSeconds (waitTime);
            (puzzleButtons[i].targetGraphic as Image).sprite = whiteButton;
        }
        StartCoroutine (SequenceChecker ());
    }
    IEnumerator SequenceChecker () {
        lastButtonPressed = -1;
        int currentIndex = 0;
        EnableAll ();
        while (currentIndex < randomButtonNumber) {
            yield return new WaitUntil (() => lastButtonPressed > -1);
            if (lastButtonPressed == randomSequence[currentIndex]) {
                currentIndex++;
                lastButtonPressed = -1;
            } else {
                Failed ();
                yield break;
            }
        }
        Succeeded ();
    }

    void Failed () {
        redLed.SetActive (true);
        Doozy.Engine.GameEventMessage.SendEvent ("MemoryPuzzle_Fail");
        evt_puzzleFailed.Invoke (attachedData);
    }
    void Succeeded () {
        greenLed.SetActive (true);
        Doozy.Engine.GameEventMessage.SendEvent ("MemoryPuzzle_Success");
        evt_puzzleSuccess.Invoke (attachedData);
    }

    void DisableAll () {
        foreach (Button btn in puzzleButtons) {
            (btn.targetGraphic as Image).sprite = whiteButton;
            btn.interactable = false;
        }
        redLed.SetActive (false);
        greenLed.SetActive (false);
    }
    void EnableAll () {
        foreach (Button btn in puzzleButtons) {
            btn.interactable = true;
            (btn.targetGraphic as Image).sprite = whiteButton;
        }
        redLed.SetActive (false);
        greenLed.SetActive (false);
    }

    // Update is called once per frame
    void Update () {

    }
}