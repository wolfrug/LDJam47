using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class SineWavePuzzle : MonoBehaviour {

    public RectTransform targetSineWaveParent;
    public RectTransform playerSineWaveParent;

    public Vector2 maxLeftRight = new Vector2 (100f, 100f);
    public Vector2 maxUpDown = new Vector2 (100f, 100f);
    void Start () {

    }

    [NaughtyAttributes.Button]
    void DebugStuff () {
        TurnVertical (-0.01f);
    }

    public void TurnHorizontal (float turn) {
        playerSineWaveParent.localScale = new Vector3 (playerSineWaveParent.localScale.x + turn, playerSineWaveParent.localScale.y, playerSineWaveParent.localScale.z);
    }
    public void TurnVertical (float turn) {
        playerSineWaveParent.localScale = new Vector3 (playerSineWaveParent.localScale.x, playerSineWaveParent.localScale.y + turn, playerSineWaveParent.localScale.z);
    }

}