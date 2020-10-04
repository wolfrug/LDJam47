using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OffScreenArrow : MonoBehaviour {

    public Transform lineRenderertarget;
    public Transform widgetTarget;
    public Transform origin;
    public Transform widget;
    public float widgetDistance = 1.5f;
    public LineRenderer lineRenderer;
    public bool active = true;

    private void Awake () {

        //pointerRectTransform = transform.Find ("Pointer").GetComponent<RectTransform> ();
    }
    public bool WidgetActivated {
        get {
            return widget.gameObject.activeInHierarchy;
        }
        set {
            widget.gameObject.SetActive (value);
        }
    }
    private void Update () {
        if (active) {
            lineRenderer.SetPosition (0, origin.position);
            lineRenderer.SetPosition (1, lineRenderertarget.position);
            if (widget != null) {
                widget.position = widgetTarget.position + ((origin.position - widgetTarget.position).normalized * widgetDistance);
                widget.transform.right = origin.position - widget.transform.position;
            };
        }

    }
}