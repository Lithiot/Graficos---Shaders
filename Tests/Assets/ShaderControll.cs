using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShaderControll : MonoBehaviour
{
    public Material mat;

    float time = 0;

    private void Awake()
    {
        mat = GetComponent<MeshRenderer>().material;
    }

    private void Update()
    {
        if (Input.GetKey(KeyCode.E))
        {
            mat.SetFloat("_DissolveProgress", time += Time.deltaTime / 2);
        }
        else if (Input.GetKey(KeyCode.Q))
        {
            mat.SetFloat("_DissolveProgress", time -= Time.deltaTime / 2);
        }
    }
}
