import SwiftUI

/**
    A View that represent audio wave
 */
struct WaveView: View {
    @EnvironmentObject var voiceNoteViewModel: VoiceNoteViewModel
    let topWaveColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
    let bottomWaveColor = #colorLiteral(red: 0.3236978054, green: 0.1063579395, blue: 0.574860394, alpha: 0.7069759748)
    
    var value: CGFloat
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(LinearGradient(colors: [Color(topWaveColor), Color(bottomWaveColor)], startPoint: .top, endPoint: .leading))
            .frame(width: (UIScreen.main.bounds.width - CGFloat(VoiceNoteViewModel.numberOfSample) * 15) / CGFloat(VoiceNoteViewModel.numberOfSample), height: value)
    }
}

struct WaveView_Previews: PreviewProvider {
    static var previews: some View {
        WaveView(value:50)
    }
}
