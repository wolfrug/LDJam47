using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class GenericWorldTextEffect : MonoBehaviour {
    public TextMeshProUGUI text;
    public Image image;
    public Animator animator;

    public bool startOnSpawn = true;
    public bool deleteOnFinished = true;

    void OnEnable () {
        if (startOnSpawn) {
            animator.SetTrigger ("Animate");
        }
    }
    public void SetUp (string Newtext, Sprite newimage, bool andAnimate = true) {
        text.text = Newtext;
        if (newimage != null) {
            image.sprite = newimage;
        }
        if (andAnimate) {
            animator.SetTrigger ("Animate");
        }
    }

    void DeleteSelf () {
        if (deleteOnFinished) {
            Destroy (gameObject);
        }
    }

}