import sys, os
sys.path.append('c:/Source/Repos/h2v-trust/backend')
from oracle.satellite_monitor import get_satellite_emissions, verify_renewable_energy_source, verify_carbon_project

def main():
    lat, lon = -3.539, -38.793  # Pecém
    print('--- Emissions Sample ---')
    emissions = get_satellite_emissions(lat, lon)
    print('location:', emissions.get('location', {}))
    print('current CO2 ppm:', emissions.get('current_emissions', {}).get('co2_ppm'))
    print('additionality:', emissions.get('additionality_analysis', {}).get('has_additionality'))
    print('\n--- Renewable Energy Sample (solar) ---')
    renewable = verify_renewable_energy_source(lat, lon, 'solar')
    print('detected:', renewable.get('detection_result'))
    print('confidence:', renewable.get('confidence'))
    print('\n--- Carbon Project Sample ---')
    project = verify_carbon_project('proj123', lat, lon)
    print('eligible:', project.get('is_eligible'))
    print('eligibility criteria:', project.get('eligibility_criteria'))

if __name__ == '__main__':
    main()
