module systasks_random();

initial begin
 // Set the seed
 //$srandom(10);
 // Randomize number between 1 and 10
 $display ("Value is %0d",$urandom_range(10,1));
 // Use seed 10 before randomize
 //$display ("Value is %0d",$urandom(10));
end

endmodule
