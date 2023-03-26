----------------------------------------------------------------------------------------------------
-- LOCATE AND CREATE DATAREFS OR COMMANDS

total_energy_fpm = find_dataref("sim/cockpit2/gauges/indicators/total_energy_fpm")

total_energy_filtered_fpm = create_dataref("laminar/ask21/total_energy_filtered_fpm","number")   -- the filtered total energy in feet/minute
total_energy_fmod_fpm = create_dataref("laminar/ask21/total_energy_fmod_fpm","number")   -- the FMOD-specific total energy in feet/minute
variometer_filtered_ms = create_dataref("laminar/ask21/variometer_filtered_ms","number") -- the filtered variometer in meter/sec

----------------------------------------------------------------------------------------------------
-- USER VARIABLES AND FUNCTIONS

-- 1st-order low-pass IIR filter:
--   Y(n) = Y(n-1) + (X(n)-Y(n-1))*d' = Y(n-1)*d + X(n)*d'
-- where:
--   input:          X(n)           <- at iteration n
--   output:         Y(n)           <- at iteration n
--   decay factor:   d  = e^(-1/T)
--   damping factor: d' = 1-d
--   time constant:  T  = -1/ln(d)  <- time for the output to reach (1-1/e) - ~65% - of its final value (with constant input)
local total_energy_time_constant = 5 -- seconds
local variometer_time_constant = 3 -- seconds
local total_energy_fmod_offset_fpm = 125 -- feet/minute

-- Nota bene:
-- - typical glider variometers - e.g. Winter's - sport a time constant of 3 seconds
-- - total energy meter is further dampened, as a matter of personal preference
-- - variometer (FMOD) sound is offset to "Netto", to match the 0-100fpm sink-climb gap in the FMOD event

function initialize()

   total_energy_filtered_fpm = total_energy_fpm
   total_energy_fmod_fpm = total_energy_filtered_fpm + total_energy_fmod_offset_fpm
   variometer_filtered_ms = total_energy_fpm * 0.00508

end

function update_datarefs()

   -- Decay factors
   total_energy_decay = math.exp(-SIM_PERIOD/total_energy_time_constant)
   variometer_decay = math.exp(-SIM_PERIOD/variometer_time_constant)

   -- Update datarefs
   total_energy_filtered_fpm = total_energy_filtered_fpm*total_energy_decay + total_energy_fpm*(1-total_energy_decay)
   total_energy_fmod_fpm = total_energy_filtered_fpm + total_energy_fmod_offset_fpm
   variometer_filtered_ms = variometer_filtered_ms*variometer_decay + total_energy_fpm*(1-variometer_decay) * 0.00508

end

----------------------------------------------------------------------------------------------------
-- REGULAR RUNTIME (X-Plane entry points)

function flight_start()
   initialize()
end

function after_physics()
   update_datarefs()
end

function after_replay()
   update_datarefs()
end
