module fifo(
    input   clk,
    input   rst_n,

    // Write interface
    input   wr_en,
    input   [7:0] data_in,
    output  full,

    // Read interface
    input   rd_en,
    output  reg [7:0] data_out,
    output  empty,

    // status
    output reg [3:0] fifo_words  // Current number of elements
);
    localparam DATA_WIDTH  = 8;
    localparam FIFO_DEPTH  = 8;

    reg [DATA_WIDTH-1:0] mem [0:FIFO_DEPTH-1];
    reg [DATA_WIDTH-1:0] write_ptr;
    reg [DATA_WIDTH-1:0] read_ptr;

    always @(posedge clk) begin
        if (!rst_n) begin
            write_ptr <= 8'd0;
        end else if (wr_en && !full) begin
            mem[write_ptr] <= data_in;
            write_ptr <= write_ptr + 1;
        end
    end

    always @(posedge clk) begin
        if (!rst_n) begin
            read_ptr <= 8'd0;
        end else if (rd_en && !empty) begin
            data_out <= mem[read_ptr];
            read_ptr <= read_ptr + 1;
        end
    end

    always @(*) begin
        if (write_ptr >= read_ptr)
            fifo_words = write_ptr - read_ptr;
        else
            fifo_words = write_ptr - read_ptr;
    end

    assign full  = ((write_ptr == read_ptr - 1) || 
                   (write_ptr == FIFO_DEPTH && read_ptr == 0));
    assign empty = (write_ptr == read_ptr);

endmodule

