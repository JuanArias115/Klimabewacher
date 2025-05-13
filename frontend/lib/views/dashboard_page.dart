// dashboard_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../viewmodels/dashboard_viewmodel.dart';
import '../models/medicion.dart';
import '../providers/theme_provider.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DashboardViewModel>();
    final medicion = viewModel.medicionActual;
    final historial = viewModel.historial;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Klimabewacher',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              context.read<ThemeProvider>().toggleTheme();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<DashboardViewModel>().fetchLatestMedicion();
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.refresh, color: Colors.white),
        tooltip: 'Actualizar datos',
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child:
            viewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : medicion == null
                ? const Center(child: Text('No hay datos disponibles'))
                : Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            _compactCard(
                              context,
                              const Icon(
                                Icons.thermostat,
                                color: Colors.orange,
                              ),
                              'Temperatura',
                              '${medicion.temperatura.toStringAsFixed(1)} °C',
                            ),
                            _compactCard(
                              context,
                              const Icon(Icons.water_drop, color: Colors.blue),
                              'Humedad',
                              '${medicion.humedad.toStringAsFixed(1)} %',
                            ),
                            _compactCard(
                              context,
                              const Icon(
                                Icons.location_on,
                                color: Colors.purple,
                              ),
                              'Ubicación',
                              // medicion.ubicacion,
                              'Köln / Deutschland',
                            ),
                            _compactCard(
                              context,
                              const Icon(Icons.schedule, color: Colors.green),
                              'Última actualización',
                              medicion.fecha
                                  .add(const Duration(hours: 2))
                                  .toString()
                                  .split(".")
                                  .first,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _graphSection(context, historial),
                        const SizedBox(height: 24),
                        // Text(
                        //   'Histórico reciente',
                        //   style: Theme.of(context).textTheme.titleMedium
                        //       ?.copyWith(fontWeight: FontWeight.bold),
                        // ),
                        // const SizedBox(height: 10),
                        // _buildMiniCardTable(
                        //   context,
                        //   historial.take(5).toList().reversed.toList(),
                        // ),
                      ],
                    ),
                  ),
                ),
      ),
    );
  }

  Widget _compactCard(
    BuildContext context,
    Icon icon,
    String label,
    String value,
  ) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2 - 20,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        child: Card(
          color: Theme.of(context).cardColor,
          elevation: 3,
          shadowColor: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                icon,
                const SizedBox(height: 6),
                Text(
                  label,
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(value, style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _graphSection(BuildContext context, List<Medicion> historial) {
    final isWide = MediaQuery.of(context).size.width > 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gráficas',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        if (isWide)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _graphCard(
                  context,
                  title: 'Temperatura (°C)',
                  color: Colors.deepOrange,
                  data: historial,
                  isTemperature: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _graphCard(
                  context,
                  title: 'Humedad (%)',
                  color: Colors.blue,
                  data: historial,
                  isTemperature: false,
                ),
              ),
            ],
          )
        else
          Column(
            children: [
              _graphCard(
                context,
                title: 'Temperatura (°C)',
                color: Colors.deepOrange,
                data: historial,
                isTemperature: true,
              ),
              const SizedBox(height: 12),
              _graphCard(
                context,
                title: 'Humedad (%)',
                color: Colors.blue,
                data: historial,
                isTemperature: false,
              ),
            ],
          ),
      ],
    );
  }

  Widget _graphCard(
    BuildContext context, {
    required String title,
    required List<Medicion> data,
    required Color color,
    required bool isTemperature,
  }) {
    final spots =
        data.map((m) {
          final fecha = m.fecha.add(const Duration(hours: 2));
          final hora = fecha.hour + fecha.minute / 60.0;
          final valor = isTemperature ? m.temperatura : m.humedad;
          return FlSpot(hora, valor);
        }).toList();

    final valoresY = spots.map((e) => e.y).toList();
    double min = valoresY.reduce((a, b) => a < b ? a : b);
    double max = valoresY.reduce((a, b) => a > b ? a : b);
    double padding = (max - min) * 0.2;

    min -= padding;
    max += padding;

    return Card(
      color: Theme.of(context).cardColor,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 280,
              child: LineChart(
                LineChartData(
                  minY: min,
                  maxY: max,
                  gridData: FlGridData(show: true, drawVerticalLine: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 50,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 36,
                        interval: 2,
                        getTitlesWidget:
                            (value, _) => Text(
                              '${value.toInt()}:00',
                              style: const TextStyle(fontSize: 12),
                            ),
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: const Border(
                      bottom: BorderSide(),
                      left: BorderSide(),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: color,
                      barWidth: 3,
                      dotData: FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniCardTable(BuildContext context, List<Medicion> data) {
    return DataTable(
      columnSpacing: 16,
      headingRowColor: MaterialStateProperty.resolveWith(
        (states) => Theme.of(context).colorScheme.primary.withOpacity(0.1),
      ),
      columns: const [
        DataColumn(label: Text('Fecha')),
        DataColumn(label: Text('Temperatura')),
        DataColumn(label: Text('Humedad')),
      ],
      rows:
          data.map((m) {
            final fecha = m.fecha.add(const Duration(hours: 2));
            return DataRow(
              cells: [
                DataCell(Text(fecha.toString().split(".").first)),
                DataCell(Text('${m.temperatura.toStringAsFixed(1)} °C')),
                DataCell(Text('${m.humedad.toStringAsFixed(1)} %')),
              ],
            );
          }).toList(),
    );
  }
}
