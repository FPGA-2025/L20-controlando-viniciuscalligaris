module fsm(
    input   clk,
    input   rst_n,

    output reg wr_en,

    output [7:0] fifo_data,
    
    input [3:0] fifo_words
);
    localparam STOP = 2'b00;
    localparam WRITE = 2'b01;
    localparam READ = 2'b10;

    reg [1:0] estado, proximo_estado;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n && estado !== STOP) begin
            estado <= STOP;
        end else begin
            estado <= proximo_estado;
        end
    end

    localparam WORDS = 5;

    always @(*) begin
        proximo_estado <= estado; 

        if (estado == STOP) begin
            proximo_estado <= WRITE;
        end
        else if (estado == WRITE) begin
            if (fifo_words >= WORDS)
                proximo_estado <= READ;
            else
                proximo_estado <= WRITE;
        end
        else if (estado == READ) begin
            if (fifo_words <= 4'd2)
                proximo_estado <= WRITE;
            else
                proximo_estado <= READ;
        end
    end

    reg [7:0] FIFO_DATA;
    assign fifo_data = FIFO_DATA;

    always @(*) begin
        FIFO_DATA <= 8'hAA;
        case (estado)
            WRITE: wr_en = 1;
            READ: wr_en = 0;
        endcase
    end

endmodule

