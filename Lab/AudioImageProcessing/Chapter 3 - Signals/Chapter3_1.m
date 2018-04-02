# Exercise 1

amp   = 0.3162;       % sinusoid amplitude (-10dB)
freq  = 110;          % frequency in Hertz (cps)
freq2 = 220;
freq3 = 440;
freq4 = 130.81;
freq5 = 261.63;
freq6 = 523.25;
dur   = 2.0;          % duration in seconds
sr    = 16000;        % the audio sample rate
phase = 0;            % initial phase (phase offset)
n     = [0: dur * sr];% sample index vector

# the sinusoid generator
x   = sin( 2 * pi * freq  / sr * n + phase);
x1  = sin( 2 * pi * freq2 / sr * n + phase);
x2  = sin( 2 * pi * freq3 / sr * n + phase);
x3  = sin( 2 * pi * freq4 / sr * n + phase);
x4  = sin( 2 * pi * freq5 / sr * n + phase);
x5  = sin( 2 * pi * freq6 / sr * n + phase);

subplot(2, 3, 1)
plot( [0 : ceil(sr / freq) - 1] / sr  ,
      x(1 : ceil(sr / freq))
     );
     
subplot(2, 3, 2)
plot( [0 : ceil(sr / freq2) - 1] / sr  ,
      x1(1 : ceil(sr / freq2))
     );
     
subplot(2, 3, 3)
plot( [0 : ceil(sr / freq3) - 1] / sr  ,
      x2(1 : ceil(sr / freq3))
     );
     
     
%sound(x5, 16000)     