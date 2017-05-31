clc;close all;clear;fclose('all');
%%
% A code developed for 
% Regeneratively Hybrid Rocket Engine Design 
% by Dr. Bilal A. Siddiqui,
% Mechanical Engineering Department,
% DHA Suffa University
% Copyrights, Bilal Siddiqui @ 2017 under MIT Liscence
%%
addpath('./fcea2');
requirements.F=5000;%newtons, required thrust
requirements.tb=10;%seconds, required burn time
requirements.pinj=80;%injection pressure (into combustor) in bars
requirements.pexit=1;%nozzle exit pressure (design point) in bars
requirements.Lstar=60*25.4/1000;%characteristic length of combustion chamer
requirements.acat=9;%contraction ratio, Ac/At
requirements.halfangle_con=45;%half angle of convergent side
requirements.halfangle_div=15;%half angle of divergent side
requirements.throatcurv=1;%ratio of curvature at throat to throat radius [0.5-1.5]

materials.wall.grade='Al';%%SS 316-L
materials.wall.servtemp=525;%850 K for Al-6061%service temp, K, i.e. around 250C
materials.wall.strength=50E6;% for Al-6061%ultimate tensile strength, Pascals, at 250C
materials.wall.fos=2;%factor of safety
materials.wall.cond=167;%Thermal Conductivity, W/m/K
materials.insert.grade='Graphite';%%Tungsten
materials.insert.cond=2;%20 for 316L%Thermal Conductivity, W/m2/K

oxidizer.name='O2';
oxidizer.carbon=0;
oxidizer.oxygen=2;
oxidizer.nitrogen=0;
oxidizer.hydrogen=0;
oxidizer.formula='O2';
oxidizer.composition=[oxidizer.carbon oxidizer.oxygen oxidizer.nitrogen oxidizer.hydrogen]';
oxidizer.molecularmass=oxidizer.carbon*12+oxidizer.oxygen*16+oxidizer.nitrogen*12+...
    oxidizer.hydrogen*1;
oxidizer.gamma=1.4;% ratio of specific heats
oxidizer.hf=0;% ratio of specific heats
fuel(1).name='n-octane';
fuel(1).carbon=26;
fuel(1).oxygen=0;
fuel(1).nitrogen=0;
fuel(1).hydrogen=2+2*fuel(1).carbon;
fuel(1).formula=['C' num2str(fuel(1).carbon) 'H' num2str(fuel(1).hydrogen)];
fuel(1).composition=[fuel(1).carbon fuel(1).oxygen fuel(1).nitrogen fuel(1).hydrogen]';
fuel(1).fraction=1;
fuel(1).molecularmass=fuel(1).carbon*12+fuel(1).oxygen*16+fuel(1).nitrogen*12+...
    fuel(1).hydrogen*1;
fuel(1).hf=-250.5;%heat of formation, kJ/mol
combustionproduct(1).carbon=1;
combustionproduct(1).oxygen=2;
combustionproduct(1).nitrogen=0;
combustionproduct(1).hydrogen=0;
combustionproduct(1).formula='CO2';
combustionproduct(2).carbon=0;
combustionproduct(2).oxygen=1;
combustionproduct(2).nitrogen=0;
combustionproduct(2).hydrogen=2;
combustionproduct(2).formula='H20';

engine.outside.h=100;%natural convection on outside surface of engine
engine.outside.Ta=298;%ambient temperature
%%
%Perform stoichiometric calculations for ideal oxidizer/fuel ratio
stoich=stoichometry(fuel,oxidizer,combustionproduct);
%%
%Optimize the fuel air ratio for the best specific impulse at given Pc
[engine.OF,nozzle.aeat,comb_chamb_st,comb_chamb_end,...
    throat,exitplane,optim]=ofr_optim(stoich,requirements,fuel,oxidizer);
%%
%Sizing the engine
[engine.cf,engine.cstar,engine.isp,propellants,tanks,geom]=...
    sizing_HRE(engine,nozzle,materials,requirements,...
    comb_chamb_st,exitplane);
%%
% Axial variation of parameters at gas core
axialvariations=...
    isentrpy(geom,comb_chamb_st,comb_chamb_end,throat,exitplane);
%%
%Heat Transfer Calculations
[axialvariations.Taw,axialvariations.Twg,axialvariations.Two,...
    axialvariations.q,axialvariations.hg]=...
    heat_transfer_unc1(materials,...
    geom,engine,comb_chamb_st,axialvariations);

%
%Plot results
plotresults(geom,axialvariations,optim);
%%
save regenHREdata;