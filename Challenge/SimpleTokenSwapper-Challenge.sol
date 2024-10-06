// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// Implement Uniswap swap interface
import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";

// Implement library to help with token transfers
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract SimpleTokenSwapper {
    // Define the Uniswap Router address and the WETH address variable
    ISwapRouter public swapRouter;
    address public constant WETH9 = 0x5300000000000000000000000000000000000004;
    // Define the constructor
    constructor(ISwapRouter _swapRouter) {
        require(address(_swapRouter) != address(0),"Zero address");
        swapRouter = _swapRouter;
    }

    // Create a swap function that takes input and output token addresses,
    // the input amount, the minimum output amount, and the recipient's address
    function swap(
        address tokenIn,         // Address of the token to swap from
        address tokenOut,        // Address of the token to swap to
        uint256 amountIn,        // Amount of input token
        uint256 amountOutMin,    // Minimum amount of output token to accept (slippage control)
        address recipient        // Address to receive the swapped tokens
    ) external {
        // Transfer the input tokens from the sender to the contract
        IERC20(tokenIn).transferFrom(msg.sender, address(this), amountIn);
        // Approve the Uniswap router to spend the input tokens
        IERC20(tokenIn).approve(address(swapRouter), amountIn);
        // Define the exact input swapping path to swap maximum amount of receiving token
        ISwapRouter.ExactInputSingleParams memory params =
            ISwapRouter.ExactInputSingleParams({
                tokenIn: tokenIn,
                tokenOut: tokenOut,
                fee: 3000,
                recipient: recipient,            
                deadline: block.timestamp + 15,
                amountIn: amountIn, 
                amountOutMinimum: amountOutMin,
                sqrtPriceLimitX96: 0       
            });

        // Call the Uniswap router's exactInputSingle function to execute the swap
        swapRouter.exactInputSingle(params);
    }
}
