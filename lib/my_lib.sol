// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 < 0.9.0;

library MyLib{
    // на відімінну від контрактів не мають свого стану
    // uint a = 12; // ! помилка
    // тобто створювати view-функції не має ніякого сенсу
    // бібліотека це набір чистих(pure) функцій

    function sum(uint a, uint b) pure external returns(uint){
        return a + b;
    }
    function get_max(uint a, uint b) pure external returns(uint){
        return a > b? a : b;
    }
}