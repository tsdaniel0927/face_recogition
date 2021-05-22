classdef project_gui < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                    matlab.ui.Figure
        LoadtestdirectoryButton     matlab.ui.control.Button
        PredictionTextAreaLabel     matlab.ui.control.Label
        PredictionTextArea          matlab.ui.control.TextArea
        AccuracyScoreTextAreaLabel  matlab.ui.control.Label
        AccuracyScoreTextArea       matlab.ui.control.TextArea
        ShowaccuracyscoreButton     matlab.ui.control.Button
        UIAxes                      matlab.ui.control.UIAxes
        UIAxes2                     matlab.ui.control.UIAxes
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: LoadtestdirectoryButton
        function LoadtestdirectoryButtonPushed(app, event)
            global im new_img dim all_H result;            
            
            addpath("train_src");
            
            all_H = read_h_mat();
            dim=0.1;
            
            filename = uigetdir('*.*'); % Get the test images directory
            [~,name1] = fileparts(filename);
            filePattern1 = fullfile(name1, '\*.pgm');
            imagefiles = dir(filePattern1);
            nfiles = length(imagefiles); 
            
            for k = 1:nfiles
                baseFileName = imagefiles(k).name; %Get the image file name
                input_image = fullfile(filename,baseFileName);
                test_image = imread(input_image);
                output = predict(all_H,test_image,dim); % Make prediction
                index = regexp(baseFileName, '\d+', 'match');
                true_index = index(1,1);
                true_class = str2double(true_index);
                
                % Compare predictions and true image
                if output == true_class
                    result="Correct ";
                    app.PredictionTextArea.Value=result
                else
                    result="Wrong ";
                    app.PredictionTextArea.Value=result
                end
                
                imshow(test_image,'Parent',app.UIAxes);
                drawnow;

                
                %Assume test file and and training file is in the same folder
                %Get image from prediction
                class_string=num2str(output);
                trainfile = strrep(filename,'test','train');%Change into train file
                stringfile=strcat('\c',class_string,'_*.pgm'); %Concatenate string
                [~,name2] = fileparts(trainfile); % Get the file name
                filePattern2 = fullfile(name2, stringfile); 
                train_imagefiles = dir(filePattern2);
                train_base_file= train_imagefiles(1).name; % Get image name
                train_img = fullfile(trainfile,train_base_file);
                train_image = imread(train_img);
                imshow(train_image,'Parent',app.UIAxes2);
                drawnow;
            end

        end

        % Button down function: UIAxes
        function UIAxesButtonDown(app, event)
            
        end

        % Value changed function: PredictionTextArea
        function PredictionTextAreaValueChanged(app, event)
            global result
            app.PredictionTextArea.Value=sprintf(result);
            drawnow;
        end

        % Button pushed function: ShowaccuracyscoreButton
        function ShowaccuracyscoreButtonPushed(app, event)
            global dim all_H acc;
            dim = 0.1;
            dir_struct = dir("test");
            y = [];
            yhat = [];
            
            for a = 3:length(dir_struct)
                %Finding the names and path for each file
                c_name = dir_struct(a).name;
                c_loc = strcat("test/",c_name);
                %Getting actual class from name
                c_class = str2double(regexp(c_name,"(?<=c).*(?=_)",'match'));
                c_img = imread(c_loc);
                %Making prediction and storing results
                p_class = predict(all_H,c_img,dim);
                y = [y,c_class];
                yhat = [yhat,p_class];
            end
            % accuracy
            acc = sum(y == yhat)/length(y);
            app.AccuracyScoreTextArea.Value = num2str(acc);
        end

        % Value changed function: AccuracyScoreTextArea
        function AccuracyScoreTextAreaValueChanged(app, event)
            global acc
            app.AccuracyScoreTextArea.Value=num2str(acc);
            
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 758 480];
            app.UIFigure.Name = 'MATLAB App';

            % Create LoadtestdirectoryButton
            app.LoadtestdirectoryButton = uibutton(app.UIFigure, 'push');
            app.LoadtestdirectoryButton.ButtonPushedFcn = createCallbackFcn(app, @LoadtestdirectoryButtonPushed, true);
            app.LoadtestdirectoryButton.BackgroundColor = [0.6078 0.8706 0.7059];
            app.LoadtestdirectoryButton.FontName = 'Segoe UI';
            app.LoadtestdirectoryButton.FontSize = 20;
            app.LoadtestdirectoryButton.FontColor = [0.6353 0.0784 0.1843];
            app.LoadtestdirectoryButton.Position = [89 120 189 54];
            app.LoadtestdirectoryButton.Text = 'Load test directory';

            % Create PredictionTextAreaLabel
            app.PredictionTextAreaLabel = uilabel(app.UIFigure);
            app.PredictionTextAreaLabel.HorizontalAlignment = 'right';
            app.PredictionTextAreaLabel.FontName = 'Segoe UI';
            app.PredictionTextAreaLabel.FontSize = 24;
            app.PredictionTextAreaLabel.FontWeight = 'bold';
            app.PredictionTextAreaLabel.FontColor = [1 0 0];
            app.PredictionTextAreaLabel.Position = [466 172 121 36];
            app.PredictionTextAreaLabel.Text = 'Prediction';

            % Create PredictionTextArea
            app.PredictionTextArea = uitextarea(app.UIFigure);
            app.PredictionTextArea.ValueChangedFcn = createCallbackFcn(app, @PredictionTextAreaValueChanged, true);
            app.PredictionTextArea.HorizontalAlignment = 'center';
            app.PredictionTextArea.FontName = 'Segoe UI';
            app.PredictionTextArea.FontSize = 24;
            app.PredictionTextArea.FontWeight = 'bold';
            app.PredictionTextArea.FontColor = [1 1 1];
            app.PredictionTextArea.BackgroundColor = [0 0.4471 0.7412];
            app.PredictionTextArea.Position = [428 122 206 50];

            % Create AccuracyScoreTextAreaLabel
            app.AccuracyScoreTextAreaLabel = uilabel(app.UIFigure);
            app.AccuracyScoreTextAreaLabel.HorizontalAlignment = 'center';
            app.AccuracyScoreTextAreaLabel.FontName = 'Segoe UI';
            app.AccuracyScoreTextAreaLabel.FontSize = 17;
            app.AccuracyScoreTextAreaLabel.FontWeight = 'bold';
            app.AccuracyScoreTextAreaLabel.FontColor = [1 0 0];
            app.AccuracyScoreTextAreaLabel.Position = [399 56 126 39];
            app.AccuracyScoreTextAreaLabel.Text = 'Accuracy Score';

            % Create AccuracyScoreTextArea
            app.AccuracyScoreTextArea = uitextarea(app.UIFigure);
            app.AccuracyScoreTextArea.ValueChangedFcn = createCallbackFcn(app, @AccuracyScoreTextAreaValueChanged, true);
            app.AccuracyScoreTextArea.FontName = 'Segoe UI';
            app.AccuracyScoreTextArea.FontSize = 17;
            app.AccuracyScoreTextArea.FontWeight = 'bold';
            app.AccuracyScoreTextArea.FontColor = [0.3922 0.8314 0.0745];
            app.AccuracyScoreTextArea.Position = [533 56 124 41];

            % Create ShowaccuracyscoreButton
            app.ShowaccuracyscoreButton = uibutton(app.UIFigure, 'push');
            app.ShowaccuracyscoreButton.ButtonPushedFcn = createCallbackFcn(app, @ShowaccuracyscoreButtonPushed, true);
            app.ShowaccuracyscoreButton.BackgroundColor = [0.0588 1 1];
            app.ShowaccuracyscoreButton.FontName = 'Segoe UI';
            app.ShowaccuracyscoreButton.FontSize = 18;
            app.ShowaccuracyscoreButton.FontColor = [1 0 0];
            app.ShowaccuracyscoreButton.Position = [89 41 190 56];
            app.ShowaccuracyscoreButton.Text = 'Show accuracy score';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, 'Test image')
            app.UIAxes.PlotBoxAspectRatio = [1.64285714285714 1 1];
            app.UIAxes.FontName = 'Segoe UI Semibold';
            app.UIAxes.FontWeight = 'bold';
            app.UIAxes.FontSize = 15;
            app.UIAxes.ButtonDownFcn = createCallbackFcn(app, @UIAxesButtonDown, true);
            app.UIAxes.Position = [19 174 329 307];

            % Create UIAxes2
            app.UIAxes2 = uiaxes(app.UIFigure);
            title(app.UIAxes2, 'Prediction Image')
            app.UIAxes2.PlotBoxAspectRatio = [1.64285714285714 1 1];
            app.UIAxes2.FontName = 'Segoe UI Semibold';
            app.UIAxes2.FontSize = 15;
            app.UIAxes2.Position = [383 174 311 307];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = project_gui

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end