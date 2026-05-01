# The Conceptual Run-Through of the Code

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

# Cycling Analysis (cycling_joint_ang_analysis.m)

This code uses data that was recorded from the cycling contraption below:

![](<img width="266" height="176" alt="image" src="https://github.com/user-attachments/assets/4e832c26-3597-42ce-83db-5e9c5ed42a07" />)

![](<img width="186" height="176" alt="image" src="https://github.com/user-attachments/assets/24107fa2-3b40-4d0c-8d26-1c8e9df254b8" />)
