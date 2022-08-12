cols = [0.25; 0.8; 0.6];
rows = [0.25; 0.1; 0.8];
vals = [0.1 0.5 0.2; 0.4 0.1 0.3; 0.9 0.2 0.0];
[j_opt, s_opt] = OptimalSplitRegression_I(vals, cols, rows);

p1.x = 0.25;
p1.y = 0.25;
p1.vals = vals(1,:);
p2.x = 0.8;
p2.y = 0.1;
p2.vals = vals(2,:);
p3.x = 0.6;
p3.y = 0.8;
p3.vals = vals(3,:);
[j_opt2, s_opt2, min_erro2] = OptimalSplitRegression([p1 p2 p3]);