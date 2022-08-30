require_relative '../lib/game'

describe Player do
  describe '.player_name' do
    it 'receives proper starter message' do
      starter_msg = 'Choose name for player 1'
      expect(described_class).to receive(:puts).with(starter_msg)
      described_class.player_name
    end

    it 'receives gets input' do
      allow(described_class).to receive(:gets).and_return('name')
      expect(described_class).to receive(:gets)
      described_class.player_name
    end

    context 'when given valid name' do
      before do
        allow(described_class).to receive(:gets).and_return('valid_name')
      end

      it 'returns the input value' do
        expect(described_class.player_name).to eql('valid_name')
      end
    end

    context 'when given invalid name' do
      before do
        invalid_name = ''
        allow(described_class).to receive(:gets).and_return(invalid_name, 'valid_name')
      end

      it 'outputs error message' do
        invalid_name_message = 'Invalid name! Please try again.'

        expect(described_class).to receive(:puts).with('Choose name for player 1')
        expect(described_class).to receive(:puts).with(invalid_name_message)
        described_class.player_name
      end
    end
  end

  describe '.player_name_valid?' do
    context 'when the name is valid' do
      it 'returns true' do
        expect(described_class.player_name_valid?('valid_name')).to be true
      end
    end

    context 'when the name is invalid' do
      it 'returns false' do
        invalid_name = ''
        expect(described_class.player_name_valid?(invalid_name)).to be false
      end
    end
  end

  describe '.player_circle_sym' do
    context 'when given valid option for circle' do
      before do
        valid_option = 'black'
        allow(described_class).to receive(:gets).and_return(valid_option)
      end

      it 'returns the option as symbol' do
        expect(described_class.player_circle_sym).to eq(:BLACK)
        described_class.player_circle_sym
      end
    end

    context 'when given invalid option for circle' do
      before do
        invalid_option = 'pink'
        valid_circle = 'black'
        allow(described_class).to receive(:gets).and_return(invalid_option, valid_circle)
      end

      it 'outputs error message' do
        invalid_circle_message = 'Invalid circle! Please try again.'

        expect(described_class).to receive(:puts).with('Choose your circle: ')
        expect(described_class).to receive(:puts).with(
          'WHITE ⚪   BLACK ⚫   RED 🔴   BLUE 🔵   GREEN 🟢   ORANGE 🟠   YELLOW 🟡   PURPLE 🟣'
        )
        expect(described_class).to receive(:puts).with(invalid_circle_message)
        described_class.player_circle_sym
      end
    end
  end

  describe '.circle_valid?' do
    context 'when the circle is valid' do
      it 'returns true' do
        valid_circle = 'black'
        expect(described_class.circle_valid?(valid_circle)).to be true
      end
    end

    context 'when the circle is invalid' do
      it 'returns false' do
        invalid_circle = 'pink'
        expect(described_class.circle_valid?(invalid_circle)).to be false
      end
    end
  end

  describe '#make_my_circle_unavailable' do
    before do
      player_color = 'black'
      allow(described_class).to receive(:gets).and_return('valid_name', player_color)
    end

    it "removes the player's circle from available circles" do
      new_available_circles = { WHITE: '⚪', RED: '🔴', BLUE: '🔵', GREEN: '🟢', ORANGE: '🟠', YELLOW: '🟡', PURPLE: '🟣' }
      expect { subject.make_my_circle_unavailable }.to change {
                                                         described_class.available_circles
                                                       }.to(new_available_circles)
    end
  end
end
