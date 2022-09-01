require_relative '../lib/connect4'

describe Connect4 do
  let(:board_empty) { Array.new(6) { Array.new(7) { nil } } }

  describe '#winner' do
    context 'when there is a winner' do
      let(:pl1) { double('Player', name: 'player1', circle: '⚫') }
      let(:pl2) { double('Player', name: 'player2', circle: '🔴') }

      context 'and he is in horizontal direction' do
        let(:board) {[
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, pl1],
          [nil, nil, nil, nil, nil, nil, pl1],
          [pl2, pl2, pl2, pl2, nil, nil, pl1]
        ]}
        subject(:connect4) { described_class.new(board, pl1, pl2) }

        it 'returns the winner' do
          expect(connect4.winner).to be pl2
        end
      end

      context 'and he is in vertical direction' do
        let(:board) {[
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, pl1],
          [nil, nil, nil, nil, nil, nil, pl1],
          [nil, nil, nil, nil, nil, nil, pl1],
          [pl2, pl2, pl2, nil, nil, nil, pl1]
        ]}
        subject(:connect4) { described_class.new(board, pl1, pl2) }

        it 'returns the winner' do
          expect(connect4.winner).to be pl1
        end
      end

      context 'and he is in right diagonal direction' do
        let(:board) {[
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, pl1, nil, nil],
          [nil, nil, nil, pl1, pl2, nil, nil],
          [nil, nil, pl1, pl2, pl1, nil, nil],
          [nil, pl1, pl2, pl2, pl1, pl2, nil]
        ]}
        subject(:connect4) { described_class.new(board, pl1, pl2) }

        it 'returns the winner' do
          expect(connect4.winner).to be pl1
        end
      end

      context 'and he is in left diagonal direction' do
        let(:board) {[
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, pl2, nil, nil, nil, nil, nil],
          [nil, pl1, pl2, nil, nil, nil, nil],
          [nil, pl1, pl1, pl2, nil, nil, nil],
          [nil, pl1, pl1, pl1, pl2, nil, nil]
        ]}
        subject(:connect4) { described_class.new(board, pl1, pl2) }

        it 'returns the winner' do
          expect(connect4.winner).to be pl2
        end
      end
    end

    context 'when there is not a winner' do
      let(:pl1) { double('Player', name: 'player1', circle: '⚫') }
      let(:pl2) { double('Player', name: 'player2', circle: '🔴') }
      let(:board) {[
        [nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, pl1],
        [nil, nil, pl2, nil, nil, nil, pl1]
      ]}
      subject(:connect4) { described_class.new(board, pl1, pl2) }

      it 'returns nil' do
        expect(connect4.winner).to be_nil
      end
    end
  end

  describe '#board_full?' do
    context 'when the board is full' do
      let(:pl1) { double('Player', name: 'player1', circle: '⚫') }
      let(:pl2) { double('Player', name: 'player2', circle: '🔴') }
      let(:board) {[
        [pl2, pl2, pl2, pl1, pl1, pl1, pl1],
        [pl2, pl2, pl2, pl2, pl1, pl1, pl1],
        [pl2, pl2, pl2, pl1, pl1, pl1, pl1],
        [pl2, pl2, pl2, pl2, pl1, pl1, pl1],
        [pl2, pl2, pl2, pl1, pl1, pl1, pl1],
        [pl2, pl2, pl2, pl2, pl1, pl1, pl1]
      ]}
      subject(:connect4) { described_class.new(board, pl1, pl2) }

      it 'returns truthy value' do
        expect(connect4.board_full?).to be_truthy
      end
    end

    context 'when the board is not full' do
      subject(:connect4) { described_class.new(board_empty, 'player1', 'player2') }

      it 'returns false' do
        expect(connect4.board_full?).to be false
      end
    end
  end

  describe '#player_position' do
    context 'when given valid position' do
      let(:valid_position) { '4' }
      let(:pl1) { double('Player', name: 'player1', circle: '⚫') }
      subject(:connect4) { described_class.new(board_empty, pl1, 'player2') }

      before do
        allow(connect4).to receive(:gets).and_return('4')
      end

      it 'returns the position as an integer' do
        expect(connect4).to receive(:gets).once
        expect(connect4.player_position(pl1)).to be 4
      end
    end

    context "when given 'quit'" do
      let(:pl1) { double('Player', name: 'player1', circle: '⚫') }
      subject(:connect4) { described_class.new(board_empty, pl1, 'player2') }

      before do
        allow(connect4).to receive(:gets).and_return('quit')
      end

      it "returns 'quit'" do
        expect(connect4.player_position(pl1)).to eql('quit')
      end
    end

    context 'when given invalid position' do
      let(:pl1) { double('Player', name: 'player1', circle: '⚫') }
      subject(:connect4) { described_class.new(board_empty, pl1, 'player2') }

      before do
        invalid_position = '0'
        allow(connect4).to receive(:gets).and_return(invalid_position, 'quit')
      end

      it "outputs 'invalid position' message" do
        expect(connect4).to receive(:puts).with("It's #{pl1.name}'s (#{pl1.circle}) turn! Pick your position.")
        expect(connect4).to receive(:puts).with('⛔ Invalid position! Please try again.')
        expect(connect4.player_position(pl1)).to eql('quit')
      end
    end
  end

  describe '#position_valid?' do
    subject(:connect4) { described_class.new(board_empty, 'player1', 'player2') }

    context 'when given num between 1 and 7' do
      it 'returns true' do
        valid_position = '4'
        expect(connect4.position_valid?(valid_position)).to be true
      end
    end

    context 'when given num that is not between 1 and 7' do
      it 'returns false' do
        invalid_position = '0'
        expect(connect4.position_valid?(invalid_position)).to be false
      end
    end

    context 'when given num between 1 and 7 in a full column' do
      let(:board) {[
        ['pl1', nil, nil, nil, nil, nil, nil],
        ['pl2', nil, nil, nil, nil, nil, nil],
        ['pl1', nil, nil, nil, nil, nil, nil],
        ['pl2', nil, nil, nil, nil, nil, nil],
        ['pl1', nil, nil, nil, nil, nil, nil],
        ['pl2', nil, nil, nil, nil, nil, nil]
      ]}
      subject(:connect4) { described_class.new(board, 'pl1', 'pl2') }

      it 'returns false' do
        position_full_column = '1'
        expect(connect4.position_valid?(position_full_column)).to be false
      end
    end
  end

  describe '#play_round' do
    let(:pl1) { double('Player', name: 'player1', circle: '⚫') }
    let(:pl2) { double('Player', name: 'player2', circle: '🔴') }
    let(:board_before) {[
      [nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil],
      [pl2, pl2, nil, nil, nil, nil, nil],
      [pl1, pl1, nil, nil, nil, nil, nil]
    ]}
    let(:board_after) {[
      [nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil],
      [nil, pl1, nil, nil, nil, nil, nil],
      [pl2, pl2, nil, nil, nil, nil, nil],
      [pl1, pl1, nil, nil, nil, nil, nil]
    ]}
    subject(:connect4) { described_class.new(board_before, pl1, pl2) }

    it 'modifies the board' do
      position = 2
      expect { connect4.play_round(pl1, position) }.to change { connect4.board }.to(board_after)
    end
  end

  describe '#available_row' do
    let(:board) {[
      ['pl1', nil, nil, nil, nil, nil, nil],
      ['pl2', nil, nil, nil, nil, nil, nil],
      ['pl1', nil, nil, nil, nil, nil, nil],
      ['pl2', nil, nil, nil, nil, nil, nil],
      ['pl1', nil, nil, nil, nil, nil, nil],
      ['pl2', 'pl2', nil, nil, nil, nil, nil]
    ]}
    subject(:connect4) { described_class.new(board, 'player1', 'player2') }

    it 'returns the first available row from the bottom' do
      col = 2 - 1 # 0-indexed
      expect(connect4.available_row(col)).to be 4
    end
  end
end
