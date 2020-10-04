using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class SineWavePuzzle : MonoBehaviour {

    public RectTransform targetSineWaveParent;
    public RectTransform playerSineWaveParent;

    public Vector2 maxLeftRight = new Vector2 (-2, 2f);
    public Vector2 maxUpDown = new Vector2 (0.2f, 2.6f);
    void Start () {

    }

    [NaughtyAttributes.Button]
    void DebugStuff () {
        TurnVertical (-0.01f);
    }

    public void TurnHorizontal (float turn) {
        playerSineWaveParent.localScale = new Vector3 (Mathf.Clamp (turn, maxLeftRight.x, maxLeftRight.y), playerSineWaveParent.localScale.y, playerSineWaveParent.localScale.z);
    }
    public void TurnVertical (float turn) {
        playerSineWaveParent.localScale = new Vector3 (playerSineWaveParent.localScale.x, Mathf.Clamp (turn, maxUpDown.x, maxUpDown.y), playerSineWaveParent.localScale.z);
    }

}