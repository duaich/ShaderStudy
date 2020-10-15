using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SetTextureUVST : MonoBehaviour
{
    //横向格子个数
    [SerializeField] private int _hCount = 1;
    //纵向格子个数
    [SerializeField] private int _VCount = 1;
    [SerializeField] private int _fps = 1;

    private int _currentIndex;

    IEnumerator Start ()
    {
        Material mat = GetComponent<Renderer>().material;

        float scale_x = 1.0f / _hCount;
        float scale_y = 1.0f / _VCount;
        float offset_x = 0;
        float offset_y = 0;
        int totalCount = _hCount * _VCount;

        while (true)
        {
            offset_x = _currentIndex % _hCount * scale_x;
            offset_y = _currentIndex / _VCount * scale_y;

            mat.SetTextureOffset("_MainTex", new Vector2(offset_x, offset_y));
            mat.SetTextureScale("_MainTex", new Vector2(scale_x, scale_y));

            yield return new WaitForSeconds(1.0f / _fps);

            _currentIndex = (++_currentIndex) % (totalCount);
        }
    }
	
	void Update ()
    {
		
	}
}
