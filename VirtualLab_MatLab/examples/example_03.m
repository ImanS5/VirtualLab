clear; clc; close all

% initialise the class tokamak
tok = tokamak;

%% Scenario 1 - Single Null

% upload the geometry information of your tokamak
tok = tok.machine_upload();
tok = tok.scenario_upload(1,1);
tok = tok.kinetic_upload();

% initialise the class geometry
geo = geometry;
geo = geo.import_geometry(tok);
geo = geo.build_geometry();
geo = geo.inside_wall();

% initialise the class equilibrium
equi1 = equilibrium;
equi1 = equi1.import_configuration(geo,tok.config);
equi1 = equi1.import_classes();
equi1.separatrix = equi1.separatrix.build_separatrix(equi1.config.separatrix,equi1.geo);

% solve equilibrium
equi1.config.GSsolver.Plotting = 0;
equi1 = equi1.solve_equilibrium();

% post processing (Opoint, Xpoint, LFCS)
equi1 = equi1.equi_pp();

% mhd and kinetic profiles
equi1  = equi1.compute_profiles();

% show uploaded geometry and target separatrix
figure(1)
clf
subplot(1,3,1)
geo.plot_wall()
hold on
equi1.plot_separatrix();
xlim([2 10])
ylim([-6 6])
title("Single Null - Target")
xlabel("R [m]")
ylabel("Z [m]")

figure(2)
clf
subplot(1,3,1)
equi1.plot_fields("pe",1)
geo.plot_wall()
title("Single Null")
xlabel("R [m]")
ylabel("Z [m]")

%% Scenario 2 - Double Null

% upload the geometry information of your tokamak
tok = tok.scenario_upload(2,1);
tok = tok.kinetic_upload();

% initialise the class geometry
geo = geometry;
geo = geo.import_geometry(tok);
geo = geo.build_geometry();
geo = geo.inside_wall();

% initialise the class equilibrium
equi2 = equilibrium;
equi2 = equi2.import_configuration(geo,tok.config);
equi2 = equi2.import_classes();
equi2.separatrix = equi2.separatrix.build_separatrix(equi2.config.separatrix,equi2.geo);

% solve equilibrium
equi2.config.GSsolver.Plotting = 0;
equi2 = equi2.solve_equilibrium();

% post processing (Opoint, Xpoint, LFCS)
equi2 = equi2.equi_pp();

% mhd and kinetic profiles
equi2  = equi2.compute_profiles();

% show uploaded geometry and target separatrix
figure(1)
subplot(1,3,2)
geo.plot_wall()
hold on
equi2.plot_separatrix();
xlim([2 10])
ylim([-6 6])
title("Double Null - Target")
xlabel("R [m]")
ylabel("Z [m]")

figure(2)
subplot(1,3,2)
equi2.plot_fields("pe",1)
geo.plot_wall()
title("Double Null")
xlabel("R [m]")
ylabel("Z [m]")

%% Scenario 3 - Negative Triangularity

% upload the geometry information of your tokamak
tok = tok.scenario_upload(3,1);
tok = tok.kinetic_upload();

% initialise the class geometry
geo = geometry;
geo = geo.import_geometry(tok);
geo = geo.build_geometry();
geo = geo.inside_wall();

% initialise the class equilibrium
equi3 = equilibrium;
equi3 = equi3.import_configuration(geo,tok.config);
equi3 = equi3.import_classes();
equi3.separatrix = equi3.separatrix.build_separatrix(equi3.config.separatrix,equi3.geo);

% solve equilibrium
equi3.config.GSsolver.Plotting = 0;
equi3 = equi3.solve_equilibrium();

% post processing (Opoint, Xpoint, LFCS)
equi3 = equi3.equi_pp();

% mhd and kinetic profiles
equi3  = equi3.compute_profiles();

% show uploaded geometry and target separatrix
figure(1)
subplot(1,3,3)
geo.plot_wall()
hold on
equi3.plot_separatrix();
xlim([2 10])
ylim([-6 6])
title("Double Null - Target")
xlabel("R [m]")
ylabel("Z [m]")

figure(2)
subplot(1,3,3)
equi3.plot_fields("pe",1)
geo.plot_wall()
title("Negative Triangularity")
xlabel("R [m]")
ylabel("Z [m]")

%% Tune Separatrix Parameters

% parametric analysis on triangularity d1
d1s = linspace(0.1,0.9,10);

% upload the geometry information of your tokamak
tok = tok.machine_upload();
tok = tok.scenario_upload(1,1);
tok = tok.kinetic_upload();

% initialise the class geometry
geo = geometry;
geo = geo.import_geometry(tok);
geo = geo.build_geometry();
geo = geo.inside_wall();

% initialise the class equilibrium
equi = equilibrium;
equi = equi.import_configuration(geo,tok.config);
equi = equi.import_classes();

figure(3)
clf
geo.plot_wall();
hold on

for i = 1 : length(d1s)

    equi.config.separatrix.d1 = d1s(i);
    equi.separatrix = equi.separatrix.build_separatrix(equi.config.separatrix,equi.geo);
    equi.plot_separatrix()

end

legend("d1 = "+d1s)

% After all scenarios are computed, store pressure fields
pe1 = equi1.pe;
pe2 = equi2.pe;
pe3 = equi3.pe;

% Find global min and max for pe
pe_min = min([min(pe1(:)), min(pe2(:)), min(pe3(:))]);
pe_max = max([max(pe1(:)), max(pe2(:)), max(pe3(:))]);

% New comparison figure with consistent color range
figure;
clf;
for i = 1:3
    subplot(1,3,i)
    switch i
        case 1
            equi1.plot_fields("pe",1);
            geo.plot_wall();
            title("Single Null");
        case 2
            equi2.plot_fields("pe",1);
            geo.plot_wall();
            title("Double Null");
        case 3
            equi3.plot_fields("pe",1);
            geo.plot_wall();
            title("Negative Triangularity");
    end
    clim([pe_min pe_max]) % Consistent color range
    xlabel("R [m]")
    ylabel("Z [m]")
    cb = colorbar();
    ylabel(cb, 'Electron Pressure [Pa]')
end
