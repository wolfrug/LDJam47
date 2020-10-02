using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.UI;

[System.Serializable]
public class LoadingFinished : UnityEvent { }
public class GenericLoadingBar : MonoBehaviour
{
    public TextMeshProUGUI loadingBarText;
    public Image loadingBar;
    [Tooltip("Set this if you want to randomize the full-screen image")]
    public Image fullScreenImage;
    [Tooltip("Add random sprites here that the full-screen image switches between")]
    public Sprite[] randomFullScreenImageSprites;
    public TextMeshProUGUI loadingScreenTipText;
    public string[] randomloadingScreenTips;
    public bool deactivateSelfOnFinish = true;
    public float currentState = 0f;
    private int max = 1;
    private int current = 0;
    public string format = "{0} / {1}";

    public bool active = false;

    public LoadingFinished onLoadFinished;
    // Start is called before the first frame update
    void Start()
    {

    }

    public void RandomizeImage()
    {
        Debug.Log("Randomizing image.");
        if (fullScreenImage != null && randomFullScreenImageSprites.Length > 0)
        {
            Sprite randomSprite = randomFullScreenImageSprites[Random.Range(0, randomFullScreenImageSprites.Length)];
            fullScreenImage.sprite = randomSprite;
        }
        else
        {
            Debug.LogWarning("Tried to randomize loading screen image but no images were found or the image component was not set.");
        }
    }
    public void RandomizeText()
    {
        if (loadingScreenTipText != null && randomloadingScreenTips.Length > 0)
        {
            loadingScreenTipText.text = randomloadingScreenTips[Random.Range(0, randomloadingScreenTips.Length)];
        }
        else
        {
            Debug.LogWarning("Tried to randomize loadingscreen tip but the text component was not set or no screen tips were addded.");
        }
    }

    public void SetupBar(int start, int endGoal)
    {
        max = endGoal;
        current = start;
        loadingBarText.text = string.Format(format, start, endGoal);
        active = true;
        RandomizeImage();
        RandomizeText();
    }
    public void PauseBar()
    {
        active = false;
    }

    public void SetState(int newValue)
    {
        if (newValue > 0)
        {
            current = newValue;
            currentState = (float)current / (float)max;
            if (current >= max)
            {
                onLoadFinished.Invoke();
                active = false;
                if (deactivateSelfOnFinish)
                {
                    gameObject.SetActive(false);
                }
            }
            if (current >= max / 2) // Randomize the text once at 50% load
            {
                RandomizeText();
            }
        };
    }
    public void AddToState(int amount)
    {
        SetState(current + amount);
    }

    // Update is called once per frame
    void Update()
    {
        if (active)
        {
            loadingBar.fillAmount = currentState;
            loadingBarText.text = string.Format(format, current, max);
        }
    }
}