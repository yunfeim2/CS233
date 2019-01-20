module keypad(valid, number, a, b, c, d, e, f, g);
   output 	valid;
   output [3:0] number;
   input 	a, b, c, d, e, f, g;
   wire wcf, wbf, wN3,
        wae, wbe, wce, waf, wN2,
        wcd, wbd, wN1,
        wad, wN0,
        wag, wcg, wnull, wquan;

   and andag(wag, a, g);
   and andcg(wcg, c, g);
   nor nornull(wnull, wag, wcg);
   and quan(wquan, a + b + c == 1, f + g + d + e == 1);
   and valid1(valid, wquan, wnull);


   and andcf(wcf, c, f);
   and andbf(wbf, b, f);
   assign wN3 = wcf + wbf;
   and andwN3(number[3], wN3, valid);

   and andae(wae, a, e);
   and andbe(wbe, b, e);
   and andce(wce, c, e);
   and andaf(waf, a, f);
   assign wN2 = wae + wbe + wce + waf;
   and andwN2(number[2], wN2, valid);

   and andcd(wcd, c, d);
   and andbd(wbd, b, d);
   assign wN1 = waf + wce + wcd + wbd;
   and andwN1(number[1], wN1, valid);

   and andad(wad, a, d);
   assign wN0 = waf + wcd + wbe + wcf + wad;
   and andwN0(number[0], wN0, valid);

endmodule // keypad
