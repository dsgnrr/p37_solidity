// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 < 0.9.0;

import "hardhat/console.sol";

contract FirstContract{
    // world_state
    // functions, fields
    /*
    public - доступ усюди, як у контракті так і за межами контракту
    private - доступ тільки у контракті
    external - доступ тільки за межами контракту
    internal - доступ тільки в контракті та у його нащадках (~protected)
    */

    /*
    ETH -> 
        wei: 1*10^-18
        gwei: 1*10^-9    
    */

    /* Data types:
    bool, int, uint, address -> STACK, sstorage тільки якщо вони створюются як стан контракту

    може все зберігатися у SSTORAGE тільки якщо створені як стан контракту
    якщо потрібно зберігати у machine state використовується ключове слово memory
    [], [][]
    bytes
    string
    struct
    enum
    */

    /* Operations:
        + - * / %
        > < >= <= ==
        || &&
        !
        =
    */

    bool public bool_value = false;

    address public owner;
    constructor(){
        /* msg -глобальний об'єкт, який зберігає данні останьої транзакації:
            -value(wei:uint256): скільки веі було надіслано
            -sender: ініціатор транзакції
        */
        owner = msg.sender;
        /* address:
            - balance(uint256)
            - transfer(value:uint256) - функція яка дозволяє надіслати вей на цей акаунт
        */
        console.log("You deployed contract at:", address(this));
        console.log("Owner balance: ", owner.balance);
    }

    string public str1 = "string";

    /* 
    - memory - write/read, тимчасовий об'єкт який зберігаєтся в опертивній пам'яті EVM(machine state), знищується після виконання функції
    - calldata - read_only, працює так само як і memory але дешевший і тільки можна читати, перезапис заборонений, використання тільки у параметрах функції
    */
    function set_string(string calldata newstr) external{
        str1 = newstr;
    }

    int public test = 0;
    function recursion(uint n) public view returns(uint256){
        // test = 5;
        if(n<=1){
            return 1;
        }
        return n * this.recursion(n-1);
    }

    // arrays
    uint[5] public arr = [1,2,3,4];

    // type[cols][rows] array2d;
    uint[3][2] public arr2d = [
        [1,2,3],
        [4,5,6]
    ];

    uint[] public dynamic_array;

    function init_array(uint[] calldata init) public{
        /*
        length:uint
        push(item)
        pop()-remove last item(return nothing)
        []
        */
        for (uint idx; idx < init.length; idx++) 
        {
            console.log("%d - %d", idx, init[idx]);
            dynamic_array.push(init[idx]);
        }
    }

    function remove_last() public{
        console.log("The last item: %d", dynamic_array[dynamic_array.length-1]);
        dynamic_array.pop();
    }

    function print_array() view public{
        console.log("dynamic_array: ");
        for (uint idx; idx < dynamic_array.length; idx++) {
            console.log("%d - %d", idx, dynamic_array[idx]);
        }
    }

    function remove_by_index(uint idx) public{
        if(idx > dynamic_array.length-1){
            revert("Index out of range");
        }
        delete dynamic_array[idx];
    }

    function create_array() public pure returns(uint[] memory new_array){
        new_array = new uint[](5);
        new_array[0] = 1;
        new_array[1] = 2;
        new_array[2] = 3;
        new_array[3] = 4;
        new_array[4] = 5;
        return new_array;
    }

    // mapping(~dictionaries)
    // mapping(type_for_key=>type_for_value) name;

    mapping(address=>uint) public balances;
    function write_balance() public{
        balances[msg.sender] = msg.sender.balance;
    }

    // byte

    bytes1 public one_byte = "b";

    bytes32 public bytes_32 = "Hello, world";
    bytes public bytes_unlimited = "Hello, world";

    function decode(bytes calldata data) public pure returns(string memory){
        return string(data);
    }

    enum Status {Paid, Delievered, Recieved}

    Status public product_status = Status.Delievered;

    // struct & payable functions

    struct Payment{
        uint value;
        uint timestamp;
        address from;
        string message;
    }
    Payment[] public payments;

    function donate(string calldata message) external payable{
        payments.push(Payment(msg.value, block.timestamp, msg.sender, message));
    }

    function transfer(address to) public payable{
        payable(to).transfer(msg.value);
    }

    /*
    transact - це ф-ції які працюють зі станом контракту, а саме змінюють цей стан. Такі функції обгортаються у транзакцію. За їх виклик, ініціатор платить комісію.
    Ціна залежить від кількості палива для виконання цієї функції

    view - це функції які також можуть працювати зі станом контракту, але тільки у режимі читання. За виклик таких функцій комісію не оплачується.

    pure - це функції за виклик яких також не оплачуєтся комісія, але в них не має доступу до стану контракта, навіть у режимі читання

    view та pure функції не обгортаються у транзакцію. Для них використовуєтся механізм call.
    
    */

    string view_str = "contract state";

    function view_get_string() public view returns(string memory){
        return view_str;
    }

    function pure_get_string() public pure returns(string memory){
        //return view_str; // ! Error: у pure функціях не має доступу до стану контракта
        return "Pure";
    }
}