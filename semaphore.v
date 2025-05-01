module Semaphore #(
    parameter CLK_FREQ = 25_000_000
)(
    input  wire clk,
    input  wire rst_n,
    input  wire pedestrian,
    output wire green,
    output wire yellow,
    output wire red
);
    localparam ESTADO_VERMELHO = 2'b00;
    localparam ESTADO_VERDE  = 2'b01;
    localparam ESTADO_AMARELO = 2'b10;

    reg [1:0] AGORA;
    reg [31:0] TEMPORIZADOR;

    assign green = (AGORA == ESTADO_VERDE);
    assign yellow = (AGORA == ESTADO_AMARELO);
    assign red = (AGORA == ESTADO_VERMELHO);

    localparam TEMPO_VERMELHO    = 5 * CLK_FREQ;
    localparam TEMPO_VERDE  = 7 * CLK_FREQ;
    localparam TEMPO_AMARELO = CLK_FREQ / 2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            AGORA <= ESTADO_VERMELHO;
            TEMPORIZADOR <= 0;
        end else begin
            case (AGORA)
                ESTADO_VERMELHO: begin
                    if (TEMPORIZADOR >= TEMPO_VERMELHO - 1) begin
                        AGORA <= ESTADO_VERDE;
                        TEMPORIZADOR <= 0;
                    end else begin
                        TEMPORIZADOR <= TEMPORIZADOR + 1;
                    end
                end
                ESTADO_VERDE: begin
                    if (pedestrian || TEMPORIZADOR >= TEMPO_VERDE - 1) begin
                        AGORA <= ESTADO_AMARELO;
                        TEMPORIZADOR <= 0;
                    end else begin
                        TEMPORIZADOR <= TEMPORIZADOR + 1;
                    end
                end
                ESTADO_AMARELO: begin
                    if (TEMPORIZADOR >= TEMPO_AMARELO - 1) begin
                        AGORA <= ESTADO_VERMELHO;
                        TEMPORIZADOR <= 0;
                    end else begin
                        TEMPORIZADOR <= TEMPORIZADOR + 1;
                    end
                end
                default: begin
                    AGORA <= ESTADO_VERMELHO;
                    TEMPORIZADOR <= 0;
                end
            endcase
        end
    end

endmodule
