# The Basics

Ok, I know it's probably scary for some of you to learn "new math" at first, but I encourage you not to worry. This is what makes the project fun, and here is the philosophy I follow:

> "If it is learnable, you can learn it."

Let that quote carry you through the project as it has for me. Good luck!

# Quaternions

Soon, you will inevitably deal with quaternions in your project. "Quaternions" sound scary, and indeed, they're a bit of a pickle to wrap your mind around. But for the purposes of this project, all you need to understand about them is that they denote **orientation** and (most importantly) **rotation** in 3D space.

"What does that mean?"

Suppose you have a 3D vector $\vec{v}$ pointing in some direction. A quaternion $\mathbf{q}$, when "multiplied" by $\vec{v}$ (I put quotes on "multiplied" because it's not really a multiplication of scalars), can rotate $\vec{v}$ in another direction.

If you've taken linear algebra, quaternions can be represented as **rotation** matrices, $R$, that can rotate a vector $\vec{v}$ in 3D space.

# The Code

I've uploaded three MATLAB codes. Two of them find joint angles for arm/leg and cycling, and the third is a user-defined function (UDF). I've commented the code the best I can, so please read through it to understand what is going on.

[Cycling Analysis](cycling_joint_ang_analysis.m)

[Calculating joint angles](joint_angle_arm_analysis.m)

[UDF](pivotangle2jointangle.m)

The code is not perfect, and sometimes you need to make adjustments in some parts of the code. Try fidgeting with it and see if it gives you the correct angles. By "correct," we always mean "approximately correct," since there will always be error when measuring joint angles.

## "How do I get data from my IMUs?"

At the beginning of the codes, you will see the following:

```
%% DATA LOADING & PRE-PROCESSING
% Load your Xsens Dot IMU quaternion data here:
IMU_A = readtable("IMU_A.csv"); % upper part of the arm
IMU_B = readtable("IMU_B.csv"); % lower part of the arm
```

You might be asking, "How do we get the CSV files of the IMUs?" I will show you :D

This tutorial is only for the Xsens Dot IMUs (scroll down to see what they look like; they're just orange little rectangles with "Xsens" written on them) that I used for my project.

### Step 1: Download the **Movella Dot** app on your PHONE
If there haven't been any updates, the app icon should look like this:

<img width="200" height="200" alt="image" src="https://github.com/user-attachments/assets/3238ef8d-0e99-41ad-b11f-1dfa04b0bd2c" />

### Step 2: Connect everything
Connect the IMU charging case to your computer with a USB cord. The IMUs inside the charging port should be charging.

Take out as many IMUs as you want to use and turn them on by pressing and holding the orange face of the IMU. After a few seconds, a green light should turn on and start blinking yellow. This means the IMU is turned on. To turn it off, press and hold the orange face again until the same green light displays for a few seconds and fades away.

In your **Movella Dot** app on your phone, connect to the IMUs in the **Dashboard** menu (make sure to have Bluetooth on).

After connecting to the IMUs, go to **Measure & Connect** and toggle on **Synchronization**. This should take a few seconds.

After the IMUs are synchronized, press **Real-time Streaming (Live mode)** to record your data. By default, the IMUs will record quaternions, but you can change the settings to make them measure something else (like Euler angles, angular acceleration, etc). My code is compatible with just quaternions, so you don't have to change any settings. Just start recording and stop whenever you want. The data should be saved inside your phone.

### Step 3: Retrieving recorded data from your phone
Now. Getting this data out of your phone is a bit of a pickle (at least for an Android user like me).

Connect your phone directly to your computer with a USB cord. Customize your phone settings so that you can transfer files between your phone and your computer.

In your computer, access your phone's **Internal Storage**. Then open **Android** folder, then **data** folder, then the **com.xsens.dot.android** folder, then **files** folder, then **logs**, and then you should arrive at the directory where all your IMU CSV data has been saved. Copy or cut these CSV files and paste them into the same folder as your MATLAB files.

Note this is only for Android. I'm not sure how different this process would be on an Apple. Ask your mentor.

# Joint Angle Calculation (joint_angle_arm_analysis.m)

Ok, the code file name includes "arm," but this code can also be used to calculate the leg's joint angles. Let me walk you through the general idea of the code.

The code basically has three parts:
* Cleaning data (reading it, normalizing, and cutting)
* Quaternions to vectors to dot product to joint angles
* Plotting

I will only talk about how we get from quaternions to joint angles.

Basically, we assume your arm is composed of **two vectors**, $\vec{v}_A$ and $\vec{v}_B$, where $\vec{v}_A$ is the vector representing your upper arm (the bicep part of your arm or whatever you call it) and $\vec{v}_B$ represents your lower arm (the forearm).

Now, intuitively, it makes sense to have the **axis of the bone** represent the direction of these vectors, which is why we chose the x-axis vector [1; 0; 0] to be our "bone axis" for these vectors. This means we position our IMUs in such a way that their x-axis in their coordinate systems (look at the image directly below) is pointed in the same direction as the bone axis. Please look below at a part of my poster presentation from Spring 2026 to see the visuals.


<img width="409" height="410" alt="image" src="https://github.com/user-attachments/assets/841e3325-24c9-4c77-bdbc-7824d1a0c2c9" />

<img width="1678" height="629" alt="image" src="https://github.com/user-attachments/assets/dd52f6f2-0418-4173-910a-168b6555889d" />


What's said in my poster presentation is exactly what is happening in my MATLAB code, look below:

```
%% Calculating Joint Angle via Dot Product

% Define the "bone axis" in the local sensor frame (usually in the
% x-direction):
boneDir = [1, 0, 0];

% For every step, compute how much the bone-axis vector rotates for each
% IMU. This finds where the "bone" is pointing in the room for every frame.
%
% Functions:
% "rotatepoint(qA, boneDir)": rotates the vector boneDir in the orientation
% of the quaternion, qA.
%
vA = rotatepoint(qA, boneDir);
vB = rotatepoint(qB, boneDir);

% perform dot product (you know this, I hope)
%
dot1 = dot(vA, vB, 2);
dot1 = max(min(dot1, 1), -1); % numerical stability clipping
finalAngle = acosd(dot1);
```

That's basically it! And then the rest of the code is just plotting the joint angle data. Easy enough, right?

Some precautions. Here are the main sources of error:
* Soft Tissue Artifact (look it up, or look at another snippet of my poster presentation down below)
* Misaligning the IMUs (imagine if your "bone axis" is misaligned; that would give the wrong angles)

Both errors are **unavoidable**. We can never fix it to perfection, but we can always minimize it using methods. I haven't gotten far into error-minimizing methods, but perhap YOU can research these methods and try to minimize it :)

Here is another snippet of my poster presentation (ignore the incomplete sentence at the beginning):

<img width="1689" height="1410" alt="image" src="https://github.com/user-attachments/assets/c0829fa9-bb17-4fb0-b458-e6d57aeeab7f" />


# Cycling Analysis (cycling_joint_ang_analysis.m)

This code uses data that was recorded from the cycling contraption below:

<img width="186" height="176" alt="image" src="https://github.com/user-attachments/assets/19341ae1-65df-47eb-8ada-288f3cbae0a5" /> <img width="266" height="176" alt="image" src="https://github.com/user-attachments/assets/9c194698-8fae-492f-bde5-55ca966280a1" />

The basic idea of this experiment was to record the joint angle of the leg through its cycling motion. Of course, angles retrieved from this will be inaccurate. To validate the data, the method we used was to utilize a **third** IMU to record the angle of rotation of the cycling wheel (I called it the "pivot angle" in my code) and use that angle to perform **forward kinematics** to predict the physical configuration of the leg and its joint angle.

Allow me to explain with my drawings :P




