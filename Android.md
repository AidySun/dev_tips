# Android

- [Android](#android)
  - [4 core components](#4-core-components)
    - [Activity](#activity)
    - [BroadCast](#broadcast)
    - [Service](#service)
    - [Content Provider](#content-provider)
  - [Binder](#binder)
  - [OpenGL](#opengl)
    - [View](#view)
  - [Android vs iOS](#android-vs-ios)


## 4 core components

- 1-activity
- 2-service
- 3-content provider
- 4-broadcast receiver

### Activity

- intent is used to communicate between Activities

### BroadCast

- https://zhuanlan.zhihu.com/p/79150113
```
1.生命周期只有十秒左右，如果在 onReceive() 内做超过十秒内的事情，就会报ANR(Application No Response) 程序无响应的错误信息，如果需要完成一项比较耗时的工作 , 应该通过发送 Intent 给 Service, 由Service 来完成 . 这里不能使用子线程来解决 , 因为 BroadcastReceiver 的生命周期很短 , 子线程可能还没有结束BroadcastReceiver 就先结束了 .BroadcastReceiver 一旦结束 , 此时 BroadcastReceiver 的所在进程很容易在系统需要内存时被优先杀死 , 因为它属于空进程 ( 没有任何活动组件的进程 ). 如果它的宿主进程被杀死 , 那么正在工作的子线程也会被杀死 . 所以采用子线程来解决是不可靠的

2. 动态注册广播接收器还有一个特点，就是当用来注册的Activity关掉后，广播也就失效了。静态注册无需担忧广播接收器是否被关闭,只要设备是开启状态,广播接收器也是打开着的。也就是说哪怕app本身未启动,该app订阅的广播在触发时也会对它起作用
```

### Service

- https://zhuanlan.zhihu.com/p/79150113
```
服务不能自己运行,需要通过Contex.startService()或Contex.bindService()启动服务

通过startService()方法启动的服务于调用者没有关系,即使调用者关闭了,服务仍然运行想停止服务要调用Context.stopService(),此时系统会调用onDestory(),使用此方法启动时,服务首次启动系统先调用服务的onCreate()-->onStart(),如果服务已经启动再次调用只会触发onStart()方法

使用bindService()启动的服务与调用者绑定,只要调用者关闭服务就终止,使用此方法启动时,服务首次启动系统先调用服务的onCreate()-->onBind(),如果服务已经启动再次调用不会再触发这2个方法,调用者退出时系统会调用服务的onUnbind()-->onDestory(),想主动解除绑定可使用Contex.unbindService(),系统依次调用onUnbind()-->onDestory();
```

- Service's `onCreate` is executed in main thread (ActivityThread), it will block UI. Don't do time-consuming task in it.


### Content Provider

- Q: why design CP
  - A: 1. 封装, 2. 跨进程共享数据，2. 共享数据库，3. 共享文件，4. 共享内存，5. 共享网�



## Binder

- Binder is used for Android only, it's registered as **misc** virtual character device. It's memory operation only, no hardware operation.
- Binder has the same driver architecture as other Linux drivers.

```
binder_open()
binder_mmap()
binder_ioctl()
```

## OpenGL

### View

- `TextureView` : incorporate OpenGL ES graphics in a samll partion of layout
- `GLSurfaceView[.Render]` : for full-screen or near-full screen graphics views
- `SurfaceView` : can build up view with additional code

## Android vs iOS

|               |Android    |iOS      |
|:--            |:----:     |:---:    |
|Language       |Kotlin     |Swift    |
|Graphic Lib    |Open GL    |Metal    |
|a   Graphic Lib|b   Open GL|c   Metal|

