using System;
using UnityEngine;
using System.Diagnostics;
using System.Collections;
using System.Collections.Generic;
using System.Runtime.InteropServices;

public class GlobalInput : MonoBehaviour
{
    [DllImport("user32.dll")]
    private static extern IntPtr ShowWindow(IntPtr hwnd, int nCmdShow);

    [DllImport("user32.dll")]
    static extern bool SetWindowPos(IntPtr hWnd, int hWndInsertAfter, int X, int Y, int cx, int cy, uint uFlags);

    [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
    private static extern IntPtr SetWindowsHookEx(int idHook, LowLevelKeyboardProc lpfn, IntPtr hMod, uint dwThreadId);

    [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
    [return: MarshalAs(UnmanagedType.Bool)]
    private static extern bool UnhookWindowsHookEx(IntPtr hhk);

    [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
    private static extern IntPtr CallNextHookEx(IntPtr hhk, int nCode, IntPtr wParam, IntPtr lParam);

    [DllImport("kernel32.dll", CharSet = CharSet.Auto, SetLastError = true)]
    private static extern IntPtr GetModuleHandle(string lpModuleName);

    [DllImport("user32.dll")]
    private static extern IntPtr GetForegroundWindow();


    static GlobalInput _instance;
    public static Action<String> callback;

    private delegate IntPtr LowLevelKeyboardProc(int nCode, IntPtr wParam, IntPtr lParam);
    private static IntPtr windowHandle;
    private static LowLevelKeyboardProc llKbProc;
    private static IntPtr hookID = IntPtr.Zero;
    private static bool isMin = false;
    private static float timeOffset = 0;
    private static IntPtr curHandle;
    private static int MAXISIZE = 5;
    private static int MINISIZE = 0;

    private enum HookType : int
    {
        WH_JOURNALRECORD = 0,
        WH_JOURNALPLAYBACK = 1,
        WH_KEYBOARD = 2,
        WH_GETMESSAGE = 3,
        WH_CALLWNDPROC = 4,
        WH_CBT = 5,
        WH_SYSMSGFILTER = 6,
        WH_MOUSE = 7,
        WH_HARDWARE = 8,
        WH_DEBUG = 9,
        WH_SHELL = 10,
        WH_FOREGROUNDIDLE = 11,
        WH_CALLWNDPROCRET = 12,
        WH_KEYBOARD_LL = 13,
        WH_MOUSE_LL = 14
    }

    public static GlobalInput Instance
    {
        get
        {
            if (_instance == null)
            {
                _instance = GameObject.FindObjectOfType<GlobalInput>();

                if (_instance == null)
                {
                    GameObject container = new GameObject("GlobalInputManager");
                    _instance = container.AddComponent<GlobalInput>();
                }
            }

            return _instance;
        }
    }

    static GlobalInput()
    {
        curHandle = GetForegroundWindow();
        SetHook();

        GameObject container = new GameObject("GlobalInputManager");
        _instance = container.AddComponent<GlobalInput>();
        DontDestroyOnLoad(_instance);
    }

    public static void Start()
    {

    }

    void OnDisable()
    {
        UnityEngine.Debug.Log("Application ending after " + Time.time + " seconds");
        UnityEngine.Debug.Log("Uninstall hook");
        UnsetHook();
    }

    void Update()
    {
        if (isMin)
        {
            timeOffset += Time.deltaTime;
            if (timeOffset > 3)
            {
                isMin = false;
                timeOffset = 0;
                ShowWindow(curHandle, MAXISIZE);
            }
        }
    }

    public static bool SetHook()
    {
        if (llKbProc == null)
            llKbProc = HookCallback;

        if (hookID != IntPtr.Zero)
            UnsetHook();

        Process curProcess = Process.GetCurrentProcess();
        ProcessModule curModule = curProcess.MainModule;

        windowHandle = GetModuleHandle(curModule.ModuleName);
        hookID = SetWindowsHookEx((int)HookType.WH_KEYBOARD_LL, llKbProc, windowHandle, 0);

        if (hookID == IntPtr.Zero)
        {
            UnityEngine.Debug.Log("Failed to hook");
            return false;
        }

        UnityEngine.Debug.Log("Hooked successfully");
        return true;
    }

    public static void UnsetHook()
    {
        UnhookWindowsHookEx(hookID);
        hookID = IntPtr.Zero;
    }

    private static IntPtr HookCallback(int nCode, IntPtr wParam, IntPtr lParam)
    {
        if (!isMin && nCode >= 0)
        {
            int vkCode = Marshal.ReadInt32(lParam);
            if (vkCode == 65)
            {
                isMin = true;
                ShowWindow(curHandle, MINISIZE);
            }
            //SetWindowPos(f, 0, 100, 100, 800, 600, 0x0040);
            UnityEngine.Debug.Log("press " + vkCode);
            callback(vkCode + "");
        }

        return CallNextHookEx(hookID, nCode, wParam, lParam);
    }
}
