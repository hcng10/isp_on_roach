
function detectobj_config(this_block)

  % Revision History:
  %
  %   15-May-2016  (23:01 hours):
  %     Original code was machine generated by Xilinx's System Generator after parsing
  %     /home/maolin/Projects/isp_on_roach/hw_eval/detection/detectobj.v
  %
  %

  this_block.setTopLevelLanguage('Verilog');

  this_block.setEntityName('detectobj');

  % System Generator has to assume that your entity  has a combinational feed through; 
  %   if it  doesn't, then comment out the following line:
  this_block.tagAsCombinational;

  this_block.addSimulinkInport('rddata');
  this_block.addSimulinkInport('rdempty');
  this_block.addSimulinkInport('reset');

  this_block.addSimulinkOutport('rdfifo');
  this_block.addSimulinkOutport('writedata');
  this_block.addSimulinkOutport('writesize');
  this_block.addSimulinkOutport('detectdata');
  this_block.addSimulinkOutport('detectsize');
  this_block.addSimulinkOutport('windowsum');
  this_block.addSimulinkOutport('bgabssumoutput');
  this_block.addSimulinkOutport('abovebgtimesoutput');
  this_block.addSimulinkOutport('belowinobjtimesoutput');
  this_block.addSimulinkOutport('stateoutput');
  this_block.addSimulinkOutport('periodcounteroutput');
  this_block.addSimulinkOutport('linecounteroutput');

  rdfifo_port = this_block.port('rdfifo');
  rdfifo_port.setType('UFix_1_0');
  rdfifo_port.useHDLVector(false);
  writedata_port = this_block.port('writedata');
  writedata_port.setType('UFix_1_0');
  writedata_port.useHDLVector(false);
  writesize_port = this_block.port('writesize');
  writesize_port.setType('UFix_1_0');
  writesize_port.useHDLVector(false);
  detectdata_port = this_block.port('detectdata');
  detectdata_port.setType('UFix_128_0');
  detectsize_port = this_block.port('detectsize');
  detectsize_port.setType('UFix_16_0');
  windowsum_port = this_block.port('windowsum');
  windowsum_port.setType('UFix_32_0');
  bgabssumoutput_port = this_block.port('bgabssumoutput');
  bgabssumoutput_port.setType('UFix_32_0');
  abovebgtimesoutput_port = this_block.port('abovebgtimesoutput');
  abovebgtimesoutput_port.setType('UFix_8_0');
  belowinobjtimesoutput_port = this_block.port('belowinobjtimesoutput');
  belowinobjtimesoutput_port.setType('UFix_8_0');
  stateoutput_port = this_block.port('stateoutput');
  stateoutput_port.setType('UFix_5_0');
  periodcounteroutput_port = this_block.port('periodcounteroutput');
  periodcounteroutput_port.setType('UFix_8_0');
  linecounteroutput_port = this_block.port('linecounteroutput');
  linecounteroutput_port.setType('UFix_8_0');

  % -----------------------------
  if (this_block.inputTypesKnown)
    % do input type checking, dynamic output type and generic setup in this code block.

    if (this_block.port('rddata').width ~= 128);
      this_block.setError('Input data type for port "rddata" must have width=128.');
    end

    if (this_block.port('rdempty').width ~= 1);
      this_block.setError('Input data type for port "rdempty" must have width=1.');
    end

    this_block.port('rdempty').useHDLVector(false);

    if (this_block.port('reset').width ~= 1);
      this_block.setError('Input data type for port "reset" must have width=1.');
    end

    this_block.port('reset').useHDLVector(false);

  end  % if(inputTypesKnown)
  % -----------------------------

  % -----------------------------
   if (this_block.inputRatesKnown)
     setup_as_single_rate(this_block,'clk','ce')
   end  % if(inputRatesKnown)
  % -----------------------------

    % (!) Set the inout port rate to be the same as the first input 
    %     rate. Change the following code if this is untrue.
    uniqueInputRates = unique(this_block.getInputRates);

  % (!) Custimize the following generic settings as appropriate. If any settings depend
  %      on input types, make the settings in the "inputTypesKnown" code block.
  %      The addGeneric function takes  3 parameters, generic name, type and constant value.
  %      Supported types are boolean, real, integer and string.
  this_block.addGeneric('PeriodNum','integer','21');
  this_block.addGeneric('InitLineNum','integer','8');
  this_block.addGeneric('BgLineNum','integer','8');

  % Add addtional source files as needed.
  %  |-------------
  %  | Add files in the order in which they should be compiled.
  %  | If two files "a.vhd" and "b.vhd" contain the entities
  %  | entity_a and entity_b, and entity_a contains a
  %  | component of type entity_b, the correct sequence of
  %  | addFile() calls would be:
  %  |    this_block.addFile('b.vhd');
  %  |    this_block.addFile('a.vhd');
  %  |-------------

  %    this_block.addFile('');
  %    this_block.addFile('');
  this_block.addFile('detectobj.v');
  this_block.addFile('WindowSumCalc.v');
  this_block.addFile('LineAbsSumCalc.v');
  this_block.addFile('PeriodAbsSumCalc.v');
  this_block.addFile('BgNoiseCalc.v');
  this_block.addFile('RemoveNoise.v');

return;


% ------------------------------------------------------------

function setup_as_single_rate(block,clkname,cename) 
  inputRates = block.inputRates; 
  uniqueInputRates = unique(inputRates); 
  if (length(uniqueInputRates)==1 & uniqueInputRates(1)==Inf) 
    block.addError('The inputs to this block cannot all be constant.'); 
    return; 
  end 
  if (uniqueInputRates(end) == Inf) 
     hasConstantInput = true; 
     uniqueInputRates = uniqueInputRates(1:end-1); 
  end 
  if (length(uniqueInputRates) ~= 1) 
    block.addError('The inputs to this block must run at a single rate.'); 
    return; 
  end 
  theInputRate = uniqueInputRates(1); 
  for i = 1:block.numSimulinkOutports 
     block.outport(i).setRate(theInputRate); 
  end 
  block.addClkCEPair(clkname,cename,theInputRate); 
  return; 

% ------------------------------------------------------------

