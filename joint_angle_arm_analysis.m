%% Finding joint angle of arm
%
% Description: This code comptues the joint angles of the arm (or leg, if
% you want)
%
% The code has issues and may not plot the graphs you want. It is your job
% to modify the code and make it output the correct angles. Remember,
% "correct" angles mean "approximately correct" angles, as there will
% always be error.
%
%% DATA LOADING & PRE-PROCESSING
% Load your Xsens Dot IMU quaternion data here:
IMU_A = readtable("yoneA1.csv"); % upper part of the arm
IMU_B = readtable("yoneB1.csv"); % lower part of the arm

% normalizing time
IMU_A(:, 2) = (IMU_A(:, 2) - IMU_A(1,2)) ./ 1000000;
IMU_B(:, 2) = (IMU_B(:, 2) - IMU_B(1,2)) ./ 1000000; 

time1 = IMU_A{:,2};

% Create and normalize quaternions
%
% Functions:
% "quaternion(IMU)": function takes quaternion data [qw, qx, qy, qz] from
% IMU and converts it into actual quaternion objects
%
% "normalize(quaternions)": normalizes the entries of the quaterions (so 
% that it represents pure rotation and no scaling.
%
qA = normalize(quaternion(IMU_A{:,3:6}));
qB = normalize(quaternion(IMU_B{:,3:6}));

% Ensure same length (so that there is no issue in plotting
len1 = min([size(qA,1), size(pivotquat, 1), size(qB, 1)]);
qA = qA(1:len1); 
qB = qB(1:len1); 
time1 = time1(1:len1);

%% IMPORTANT
% Choose the time interval you want to plot and observe (this can be made
% into a user input function, if you want)
%
% Example: 
% Select indices corresponding to the time range between 1 and 53 seconds:
timeRangeIndices = time1 >= 1 & time1 <= 53;
qA = qA(timeRangeIndices);
qB = qB(timeRangeIndices);
time1 = time1(timeRangeIndices);

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

%% PLOTTING
figure;
plot(time1, finalAngle, 'r', 'LineWidth', 1.5);
title("Joint Angles of Leg during Cycling");
xlabel('Time (s)');
ylabel('Angle (deg)');
grid on;