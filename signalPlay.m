clear all; close all; clc;

f0 = 1.001; % The fundamental frequency needs to be greater than unity due to normalizing the time interval of the sample...

D = 2; % D needs to be greater than or equal to 2 in the integers... 

phi  = pi / 2; % Phase offset to center power signal over time...

S = [ 1e3 8e3 44.1e3 96e3 ];

Fs = S( 1, 3 ); % We can see the effect of machine sample rate in the pulse superposition.

t = 0:1/Fs:(1-1/Fs);

m = ( 0:1:size( t, 2 ) - 1 );

F = 1; uu = 1;
for i = 1:1:size(t, 2)

    % Find hamonic frequency infemum. This ensures no aliasing in the
    % system.

    if( m( i ) * f0 >= Fs / D )

        F( 1, uu ) = i; uu = uu + 1;
    end
end

G = size( find( F ~= 0 ), 2 );

if( G )

    % We need to clip the time inteval to include only those frequencies
    % satified by the Shannon-Nyquist Theorem...

    % Eventhough these are interference signals, we can keep them in the
    % anti-aliasing range of the system dicated by the sample rate...

    T = t( 1:1:2 * F( 1, 1 ) ); M = m( 1:1:size( T, 2 ) );

    % Power waveform...

    Y = cos( 2 * pi * f0 * M .* T ) + sin( ( 2 * pi * f0 * ( M + 1 ) .* T ) - phi ); % This generates a superposition of sinusoidal power harmomics.
else 

    y = cos( 2 * pi * f0 * m .* t ) + sin( 2 * pi * f0 * ( m + 1 ) .* t - phi );
end

H = Fs / f0;

% plot( T(1:1:H), X(1:1:H), 'k' ); hold on;

% pause(0.5);
% 
% Y = 10; SECONDS = 10 * Y; 
% 
% for i = 1:1:SECONDS
% 
%     sound( X, Fs );
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[ z, Fs ] = audioread('John Legend - Nervous _Lyrics_.mp4');

LB = size( z, 1 ) / 2 - size( T, 2 ) / 2; 

UB = size( z, 1 ) / 2 + size( T, 2 ) / 2 - 1;

C(1,:) = z(LB:UB,1); 

audiowrite('timeSample.mp4',C,S(1,3))

figure( 'name', 'John Legend - Nervous Audio Sample');
subplot(3,1,1);
plot( T(1:1:H), C(1:1:H), 'g' ); 
title('John Legend - Nervous Audio Sample without Noise');
xlabel("T");
ylabel("C[T]");
% yline(0);
legend( 'Target Signal' );

sound( C, S( 1, 3 ) ); pause( 3 );

SIG = sum( abs( C ), 2 ); NOI = sum( abs( Y ), 2 );

s = rng;

AWGN = sqrt( SIG / NOI ) .* randn( 1, size(C, 2) );

X = cos( 2 * pi * f0 * M .* T ) + sin( ( 2 * pi * f0 * ( M + 1 ) .* T ) - phi ) + C(1,1:end) + AWGN;

subplot(3,1,2);
plot( T(1:1:H), AWGN(1:1:H), 'm', T(1:1:H), Y(1:1:H), 'k', T(1:1:H), C(1:1:H), 'c'); hold on;
title('John Legend - Nervous Audio Sample with Noise');
xlabel("T");
ylabel( "C[T]");
% yline(0);
legend('AWGN', 'Harmonic Interference', 'Target Signal' );

sound( X, S( 1, 3 ) ); pause(3);

audiowrite('timeSampleNoise.mp4',X,S(1,3)) % Notice that the proper time of the sample is the normalized value of the interval.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% We need to de-noise the signal X, and then classify the origination of
% the signal.

% A simple idea for de-noising is to filter all frequency hamoics and AWGN from the
% signal...

% New interference and noise...

AWGN = sqrt( SIG / NOI ) .* randn( 1, size(C, 2) );

if( G )

    % We need to clip the time inteval to include only those frequencies
    % satified by the Shannon-Nyquist Theorem...

    % Eventhough these are interference signals, we can keep them in the
    % anti-aliasing range of the system dicated by the sample rate...

    T = t( 1:1:2 * F( 1, 1 ) ); M = m( 1:1:size( T, 2 ) );

    % Power waveform...

    Y = cos( 2 * pi * f0 * ( M + 0.5 ) .* T ) + sin( ( 2 * pi * f0 * ( M + 1.5 ) .* T ) - phi ); % This generates a superposition of sinusoidal power harmomics.
else 

    y = cos( 2 * pi * f0 * m .* t ) + sin( 2 * pi * f0 * ( m + 1 ) .* t - phi );
end

Y = cos( 2 * pi * f0 * M .* T ) + sin( ( 2 * pi * f0 * ( M + 1 ) .* T ) - phi ) + C(1,1:end) + AWGN;

X = Y;

% Old interference and noise...

% X = X - ( cos( 2 * pi * f0 * M .* T ) + sin( ( 2 * pi * f0 * ( M + 1 ) .* T ) - phi ) ) - AWGN;

XX = 0;
for i = 1:1:size(C,2)

    if( X( i ) <= C( i ) - sqrt( SIG / NOI ) || X( i ) >= C( i ) + sqrt( SIG / NOI ) )

        XX = XX + 1; % Wee need to account for error propagation in the system from subtraction.
    end
end

ERROR = XX / size(X,2);

if( ERROR <= 0.01 )
    disp("This is John Legend - Nervous!")
end

subplot(3,1,3);
plot( T(1:1:H), X(1:1:H), 'r' ); hold on;
title('John Legend - Nervous Audio Sample De-Noised');
xlabel("T");
ylabel( "C[T]");
% yline(0);
legend( 'Mixed Signal' );

sound( X, S( 1, 3 ) );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Signal Processing: Ph.D-Level Topics...

% De-noise...

% Classify...

% Track...

% Guidance...

% Encryption...

% Compression...

