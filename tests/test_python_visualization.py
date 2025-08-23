import unittest
import os
import sys
import pandas as pd
from unittest.mock import patch, MagicMock, call

# Add the script's directory to the Python path to allow importing
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..', 'python_visualization')))

# Now we can import the script we want to test
import plot_synapse

class TestPythonVisualization(unittest.TestCase):

    def setUp(self):
        """Set up a mock DataFrame and a test directory for frames."""
        self.mock_data = {
            'time': [0.0, 0.1, 0.2, 0.3],
            'synaptic_weight': [0.5, 0.55, 0.6, 0.65],
            'pre_activity': [1, 0, 1, 0],
            'post_activity': [0, 1, 1, 0]
        }
        self.mock_df = pd.DataFrame(self.mock_data)

        self.test_frames_dir = 'test_frames'
        os.makedirs(self.test_frames_dir, exist_ok=True)

        self.frames_dir_patch = patch('plot_synapse.FRAMES_DIR', self.test_frames_dir)
        self.frames_dir_patch.start()

    def tearDown(self):
        """Clean up the test directory."""
        self.frames_dir_patch.stop()
        if os.path.exists(self.test_frames_dir):
            for f in os.listdir(self.test_frames_dir):
                os.remove(os.path.join(self.test_frames_dir, f))
            os.rmdir(self.test_frames_dir)

    @patch('matplotlib.pyplot.savefig')
    @patch('matplotlib.pyplot.show')
    @patch('matplotlib.pyplot.close')
    @patch('matplotlib.pyplot.subplots')
    def test_unit_plot_simulation_step_runs_without_error(self, mock_subplots, mock_close, mock_show, mock_savefig):
        """
        Unit Test: Ensures plot_simulation_step runs and attempts to save a figure.
        """
        mock_fig = MagicMock()
        mock_ax = MagicMock()
        mock_subplots.return_value = (mock_fig, (mock_ax, mock_ax))

        plot_synapse.plot_simulation_step(self.mock_df, step_index=2)

        mock_savefig.assert_called_once()
        self.assertTrue(mock_close.called)

    def test_bdd_given_data_when_plotting_then_frame_is_saved(self):
        """
        BDD-Style Test: Given simulation data, when plotting, a PNG frame is saved.
        """
        step_index = 1
        expected_frame_path = os.path.join(self.test_frames_dir, f'frame_{step_index:04d}.png')

        plot_synapse.plot_simulation_step(self.mock_df, step_index)

        self.assertTrue(os.path.exists(expected_frame_path))

    @patch('plot_synapse.os.path.exists', return_value=False)
    @patch('builtins.print')
    def test_main_handles_file_not_found(self, mock_print, mock_exists):
        """Tests that the main function prints an error if the data file is not found."""
        plot_synapse.main()
        mock_print.assert_any_call(f"Error: Data file not found at {plot_synapse.DATA_FILE}")

    @patch('plot_synapse.plot_simulation_step')
    @patch('plot_synapse.pd.read_csv')
    @patch('plot_synapse.os.path.exists', return_value=True)
    def test_main_runs_successfully(self, mock_exists, mock_read_csv, mock_plot_step):
        """Tests the main function's successful execution path."""
        mock_read_csv.return_value = self.mock_df

        plot_synapse.main()

        self.assertEqual(mock_plot_step.call_count, len(self.mock_df))
        mock_plot_step.assert_has_calls([
            call(self.mock_df, 0),
            call(self.mock_df, 1),
            call(self.mock_df, 2),
            call(self.mock_df, 3),
        ])

    @patch('matplotlib.pyplot.Circle')
    def test_neuron_activity_visualization_colors(self, mock_circle):
        """Tests that neuron activity circles are colored correctly."""
        # Step 2: pre_activity=1, post_activity=1 -> both red
        plot_synapse.plot_simulation_step(self.mock_df, step_index=2)
        mock_circle.assert_has_calls([
            call((0.4, 0.5), 0.1, color='red'),
            call((0.6, 0.5), 0.1, color='red')
        ], any_order=True)

        mock_circle.reset_mock()

        # Step 1: pre_activity=0, post_activity=1 -> one gray, one red
        plot_synapse.plot_simulation_step(self.mock_df, step_index=1)
        mock_circle.assert_has_calls([
            call((0.4, 0.5), 0.1, color='gray'),
            call((0.6, 0.5), 0.1, color='red')
        ], any_order=True)

if __name__ == '__main__':
    unittest.main()
