// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

contract RegexMatch {
    address constant REGEX_MATCH_ADDRESS = address(0x15);

    function matchPattern(bytes memory pattern, bytes memory input)
        public
        view
        returns (bool, bytes memory)
    {
        require(pattern.length <= 255, "Pattern too long");
        require(input.length <= 255, "Input too long");

        bytes memory data = abi.encodePacked(
            uint8(pattern.length),
            pattern,
            uint8(input.length),
            input
        );

        (bool success, bytes memory output) = REGEX_MATCH_ADDRESS.staticcall(data);
        require(success, "Regex match failed");

        bool isMatch = output[0] != 0;
        if (isMatch) {
            uint8 matchLength = uint8(output[1]);
            bytes memory matchedSubstring = new bytes(matchLength);
            for (uint8 i = 0; i < matchLength; i++) {
                matchedSubstring[i] = output[2 + i];
            }
            return (true, matchedSubstring);
        } else {
            return (false, "");
        }
    }
}
