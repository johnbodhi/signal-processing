clear all; close all; clc;

f0 = 10; % f0 needs to be greater than or equal to N...

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

    T = t( 1:1:2*F( 1, 1 ) ); M = m( 1:1:size( T, 2 ) );

    % Power waveform...

    X = cos( 2 * pi * f0 * M .* T ) + sin( ( 2 * pi * f0 * ( M + 1 ) .* T ) - phi ); % This generates a superposition of power harmomics.
else 

    x = cos( 2 * pi * f0 * m .* t ) + sin( 2 * pi * f0 * ( m + 1 ) .* t - phi );
end

H = Fs / f0;

plot( T(1:1:H), X(1:1:H), 'k' ); hold on;

pause(0.5);

Y = 10; SECONDS = 10 * Y; 

for i = 1:1:SECONDS

    sound( X, Fs );
end

