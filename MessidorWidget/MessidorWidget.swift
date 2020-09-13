//
//  MessidorWidget.swift
//  MessidorWidget
//
//  Created by patrick philipot on 06/09/2020.
//  Copyright © 2020 stgpcs. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct MessidorWidgetEntryView : View {
    var entry: Provider.Entry
    let cal = CalendrierRevolutionnaire()
    
    var body: some View {
        let date: Date = entry.date
        let nomDuJour : String = cal.dateRepublicaine(pourDateGregorienne: date, avecNomDuJour: true).components(separatedBy: "@")[1]
        
        ZStack {
            Color.blue
            VStack {
                Text("Date dans le calendrier révolutionnaire")
                    .font(.subheadline)
                Spacer()
                Text("\(cal.dateRepublicaine(pourDateGregorienne: date, avecNomDuJour: false))")
                    .padding()
                Spacer()
                Text("\(nomDuJour)")
                    .font(.subheadline)
            }
            .padding()
            .foregroundColor(.white)
        }
        //.background(Color.blue)
        
    }
    
}

@main
struct MessidorWidget: Widget {
    let kind: String = "MessidorWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            MessidorWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Messidor")
        .description("Un widget révolutionnaire.")
    }
}

struct MessidorWidget_Previews: PreviewProvider {
    static var previews: some View {
        MessidorWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
