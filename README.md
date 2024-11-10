# 📺CPU-project

---

**Project Score:**
<img width="575" alt="image" src="https://github.com/user-attachments/assets/c8143937-430e-49ef-af3a-6c05394aa11c">

---

**Grading Criteria（1）:**

1. The grading will be based on code standards (structured design, variable naming, coding standards, comments), documentation, and functional acceptance demonstration.

2. The project score consists of two parts: the base score (100 points) + bonus (15 points). If the score exceeds 100, the excess will be proportionally included in the final score.

3. **Base Score:**
   - Basic Functionality (70 points)
   - Code Standards (3 points)
   - Documentation (12 points)
   - Defense Score (15 points; this score reflects individual defense performance and is not affected by contribution ratio)

4. **Basic Functionality:**
   - 1) Implement a single-cycle CPU from the textbook (supporting RISC-VI instructions: `lw`, `sw`, `beq`, `add`, `sub`, `and`, `or`). Submodules must pass OJ testing. (10 points)
   - 2) Extend the functionality and instruction set of the single-cycle CPU implemented in 1) to support board-level testing. (60 points)
   - The CPU code for board testing must match the code submitted to OJ for the specified modules and ports (see Appendix xx for specific modules and ports).
   - Testing should cover basic scenarios 1 and 2.
   - Use peripherals as required: buttons (functional buttons like data confirmation), dip switches (data input), LEDs (operand display), and seven-segment displays (result display). Due to the complexity of testing, data input and display should consider basic user experience; otherwise, points may be deducted at the discretion of the evaluator.

5. **Bonus: 15 points**
   - Note: The bonus must include corresponding code, demonstration, documentation, and video.
   - Documentation should describe the implementation of the bonus-related features (including implementation mechanisms, test cases, and test results). The video should only record the demonstration of the bonus features.
   - If the documentation or video for the bonus is missing, the bonus score will be reduced to 60%. For example, if the bonus feature score is 10 points but lacks a valid video or documentation, the total bonus score = 10 * 0.6 = 6 points.

6. **Supplementary Note:**
   - If board-level testing cannot be performed, the project’s total score will be adjusted to (0.3 ~ 0.5) times the original score, depending on the situation.

---

**Grading Criteria (2):**

**Bonus Functionality [max: 15]** includes but is not limited to:

1. **Support for Complex Peripheral Interfaces** (e.g., VGA interface, keyboard interface) [max: 2]
   - Note: In this course, complex peripheral interfaces are only supported through a combination of hardware and software (i.e., access to these peripherals must be achieved either through specific instructions or address information within instructions, rather than solely through hardware control). This course's bonus focuses more on CPU architecture optimization or application scenarios, so the effectiveness of implementing peripherals such as VGA or keyboard will not be a primary factor in the bonus score.

2. **Single FPGA Chip Programming with UART Interface for Switching Between Multiple Test Scenarios** [max: 2]

3. **Single-Cycle CPU Implementation Based on RISC-V32I ISA with New Design Concepts (e.g., Pipeline)** [6-12]
   - Note: The implementation must correctly run code containing at least one data hazard. It should be able to modify the assembly code on-site and pass the test. (Please refer to the later published documentation for basic test cases.)

4. **Implementation of Additional Instructions in the Existing RISC-V32I ISA** (e.g., `lui`, `auipc`, `ecall`) with Testing Examples [1-6]

5. **Hardware-Software Co-Design Implementation or Application Based on CPU** [2-10]
   - Tools created within the hardware-software co-design toolchain, such as an extended assembly tool supporting the `auipc` instruction on the current CPU, a tool for generating adjustable ROM/RAM size `coe` files, hardware implementations or communication tools with adjustable UART rates, etc.
   - Software applications that communicate and cooperate with the CPU, such as graphics processing, sound processing, or an advanced game controller.

**Note:** If the implementation is based on a LoongArch instruction CPU, there is no need to implement a RISC-V CPU. (Functionality points and bonus scores will be transferred to the LoongArch instructions.) The bonus score will be multiplied by a factor of 1.05 to 1.1 based on the completion level (but the bonus will not exceed 15 points). Ensure that the documentation compares the implementation of this architecture with the RISC-V implementation introduced in the course; otherwise, the related bonus will be zero.

---

**Scenario 1: Use Case Descriptions**

**Use Case ID:**
- **3'b000**: Input test number `a` and test number `b`, and display the 8-bit values of `a` and `b` on the output device (LED).

- **3'b001**: Input test number `a`, store it in a register using the `lb` instruction, and display the 32-bit register's value in hexadecimal format on the output device (seven-segment display or VGA). Also, save this number to memory. (In use cases **3'b011** to **3'b111**, the `lw` instruction will be used to read the value of `a` from this memory unit for comparison.)

- **3'b010**: Input test number `b`, store it in a register using the `lbu` instruction, and display the 32-bit register's value in hexadecimal format on the output device (seven-segment display or VGA). Also, save this number to memory. (In use cases **3'b011** to **3'b111**, the `lw` instruction will be used to read the value of `a` from this memory unit for comparison.)

- **3'b011**: Use the `beq` instruction to compare test number `a` and test number `b` (from use cases **3'b001** and **3'b010**). If the condition is met, light up the LED; if the condition is not met, the LED remains off.

- **3'b100**: Use the `blt` instruction to compare test number `a` and test number `b` (from use cases **3'b001** and **3'b010**). If the condition is met, light up the LED; if the condition is not met, the LED remains off.

- **3'b101**: Use the `bge` instruction to compare test number `a` and test number `b` (from use cases **3'b001** and **3'b010**). If the condition is met, light up the LED; if the condition is not met, the LED remains off.

- **3'b110**: Use the `bltu` instruction to compare test number `a` and test number `b` (from use cases **3'b001** and **3'b010**). If the condition is met, light up the LED; if the condition is not met, the LED remains off.

- **3'b111**: Use the `bgeu` instruction to compare test number `a` and test number `b` (from use cases **3'b001** and **3'b010**). If the condition is met, light up the LED; if the condition is not met, the LED remains off.

---

**Scenario 2: Use Case Descriptions**

**Use Case ID:**

- **3'b000**: Input an 8-bit number and calculate the number of leading zeros. Output the count of leading zeros.

- **3'b001**: Input a 16-bit IEEE 754 half-precision floating-point number, perform rounding up, and output the rounded result.

- **3'b010**: Input a 16-bit IEEE 754 half-precision floating-point number, perform rounding down, and output the rounded result.

- **3'b011**: Input a 16-bit IEEE 754 half-precision floating-point number, perform rounding to the nearest integer, and output the rounded result.

- **3'b100**: Input two 8-bit numbers `a` and `b` in two separate steps. Perform addition on `a` and `b`. If the sum exceeds 8 bits, extract the high bits, accumulate them into the sum, and output the result after taking the bitwise NOT of the sum.

- **3'b101**: Input a 12-bit data in little-endian format via switches, and present it in big-endian format on the output device.

- **3'b110**: Compute the number of Fibonacci numbers less than the input data recursively. Record the number of push and pop operations, and display the sum of the push and pop counts on the output device.

- **3'b111**: Compute the number of Fibonacci numbers less than the input data recursively. Record the data pushed and popped, and display the parameters pushed onto the stack. Each parameter should be displayed for 2-3 seconds. (Note: The output here does not focus on the `ra` register's push and pop operations.)

---
