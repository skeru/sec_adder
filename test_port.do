onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /test_port/a
add wave -noupdate /test_port/b
add wave -noupdate /test_port/r
add wave -noupdate /test_port/not_a
add wave -noupdate /test_port/a_xor_b
add wave -noupdate /test_port/out_a_sign
add wave -noupdate /test_port/out_b_sign
add wave -noupdate /test_port/not_a_sign
add wave -noupdate /test_port/a_xor_b_sign
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {1 us}
