import { IsNumber, IsOptional, IsString } from 'class-validator';

export class ConsultaDto {
  @IsNumber()
  public id: number;

  @IsNumber()
  public dv: number;

  @IsString()
  @IsOptional()
  public primer_apellido: string;

  @IsString()
  @IsOptional()
  public segundo_apellido: string;

  @IsString()
  @IsOptional()
  public primer_nombre: string;

  @IsString()
  @IsOptional()
  public segundo_nombre: string;

  @IsString()
  @IsOptional()
  public razonSocial: string;

  @IsString()
  public fecha_actual: string;

  @IsString()
  public estado: string;
}
