using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GravityController : MonoBehaviour {
    public Vector2 gravity = new Vector2 (0f, -1f);
    // Start is called before the first frame update
    void Start () {
        SetGravity (gravity.y);
    }

    public void SetGravity (float newGravity) {
        Physics2D.gravity = new Vector2 (0f, newGravity);
        gravity = new Vector2 (0f, newGravity);
    }

    // Update is called once per frame
    void Update () {

    }
}