clear all; close all; clc;

f0 = 1.001; % The fundamental frequency needs to be greater than 1...

D = 2; % D needs to be greater than or equal to 2 in the integers... 

phi  = pi / 2; % Phase offset to center power signal form zero to zero...

S = [ 1e3 8e3 44.1e3 96e3 ];

Fs = S( 1, 4 ); % We can see the effect of machine smaple rate in the pulse superposition.

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

    T = t( 1:1:2 * F( 1, 1 ) ); M = m( 1:1:size( T, 2 ) );

    % Power waveform...

    Y = cos( 2 * pi * f0 * M .* T ) + sin( ( 2 * pi * f0 * ( M + 1 ) .* T ) - phi ); % This generates a superposition of power harmomics.
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

C(1,:) = z( LB:UB, 1);

% sound( C, S( 1, 3 ) );

SIG = sum( abs( C ), 2 ); NOI = sum( abs( Y ), 2 );

s = rng;

AWGN = sqrt( SIG / NOI ) .* randn( 1, size(C, 2) );

X = cos( 2 * pi * f0 * M .* T ) + sin( ( 2 * pi * f0 * ( M + 1 ) .* T ) - phi ) + C(1,1:end) + AWGN;

plot( T(1:1:H), X(1:1:H), 'g' ); hold on;
plot( T(1:1:H), AWGN(1:1:H), 'm' ); hold on;
plot( T(1:1:H), Y(1:1:H), 'k' ); hold on; 

sound( X, S( 1, 3 ) );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
